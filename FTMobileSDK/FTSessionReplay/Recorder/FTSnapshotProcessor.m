//
//  FTSnapshotProcessor.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/12.
//  Copyright © 2024 TRUEWATCH. All rights reserved.
//

#import "FTSnapshotProcessor.h"
#import "FTViewTreeSnapshotBuilder.h"
#import "FTViewAttributes.h"
#import "FTViewAttributes.h"
#import "FTSRWireframe.h"
#import "FTSRWireframesBuilder.h"
#import "NSDate+FTUtil.h"
#import "FTSRRecord.h"
#import "FTNodesFlattener.h"
#import "FTFileWriter.h"
#import "FTConstants.h"
#import "FTModuleManager.h"
#import "FTSRUtils.h"
#import "FTTouchSnapshot.h"
#import "FTLog+Private.h"

NSTimeInterval const kFullSnapshotInterval = 20.0;

@interface FTSnapshotProcessor()
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) id<FTWriter> writer;
/// Record basic data of the previous page to determine if it's a new page
@property (nonatomic, strong) FTViewTreeSnapshot *lastSnapshot;
@property (nonatomic, assign) CFTimeInterval lastSnapshotTimestamp;
/// Used to compare incremental data
@property (nonatomic, strong) NSArray<FTSRWireframe *> *lastSRWireframes;
@property (nonatomic, strong) FTNodesFlattener *flattener;
@property (nonatomic, strong) NSMutableDictionary *recordsCountByViewID;
@property (nonatomic, assign) BOOL needUpdateFullSnapshot;
@end
@implementation FTSnapshotProcessor
-(instancetype)initWithQueue:(dispatch_queue_t)queue writer:(id<FTWriter>)writer{
    self = [super init];
    if(self){
        _queue = queue;
        _writer = writer;
        _flattener = [[FTNodesFlattener alloc]init];
        _recordsCountByViewID = [NSMutableDictionary new];
    }
    return self;
}
- (void)process:(FTViewTreeSnapshot *)viewTreeSnapshot touchSnapshot:(FTTouchSnapshot *)touchSnapshot{
    __weak typeof(self) weakSelf = self;
    dispatch_async(self.queue, ^{
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) return;
        [strongSelf processSync:viewTreeSnapshot touchSnapshot:touchSnapshot];
    });
}
- (void)processSync:(FTViewTreeSnapshot *)viewTreeSnapshot touchSnapshot:(FTTouchSnapshot *)touchSnapshot{
    @try {
        NSMutableArray<FTSRWireframe> *wireframes = (NSMutableArray<FTSRWireframe>*)[[NSMutableArray alloc]init];
        NSArray<id <FTSRWireframesBuilder>> *nodes = [self.flattener flattenNodes:viewTreeSnapshot];
        for (id<FTSRWireframesBuilder> builder in nodes) {
            [wireframes addObjectsFromArray:[builder buildWireframes]];
        }
        // 2.Convert data to storage required format
        NSMutableArray<FTSRRecord> *records =(NSMutableArray<FTSRRecord>*)[[NSMutableArray alloc]init];
        BOOL force = NO;
        // 3.Determine if it's new addition or new View
        BOOL isNewView = self.lastSnapshot == nil || self.lastSnapshot.context.sessionID != viewTreeSnapshot.context.sessionID || self.lastSnapshot.context.viewID != viewTreeSnapshot.context.viewID;
        BOOL isTimeForFullSnapshot = [self isTimeForFullSnapshot];
        BOOL fullSnapshotRequired = isNewView || isTimeForFullSnapshot;
        // 3.1.New view full save
        if (isNewView || fullSnapshotRequired){
            force = YES;
            // meta focus full
            FTSRMetaRecord *metaRecord = [[FTSRMetaRecord alloc]initWithViewTreeSnapshot:viewTreeSnapshot];
            FTSRFocusRecord *focusRecord = [[FTSRFocusRecord alloc]initWithTimestamp:[viewTreeSnapshot.context.date ft_millisecondTimeStamp]];
            focusRecord.hasFocus = YES;
            FTSRFullSnapshotRecord *fullRecord = [[FTSRFullSnapshotRecord alloc]initWithTimestamp:[viewTreeSnapshot.context.date ft_millisecondTimeStamp]];
            fullRecord.wireframes = wireframes;
            [records addObject:metaRecord];
            [records addObject:focusRecord];
            [records addObject:fullRecord];
        }else if(self.lastSRWireframes == nil){
            //3.2 Has lastSnapshot, but no wireframe collected
            FTSRFullSnapshotRecord *fullRecord = [[FTSRFullSnapshotRecord alloc]initWithTimestamp:[viewTreeSnapshot.context.date ft_millisecondTimeStamp]];
            fullRecord.wireframes = wireframes;
            [records addObject:fullRecord];
        }else{
            // 3.3.1.View already exists, perform incremental judgment, algorithm comparison, get increment, decrement, update
            MutationData *mutation = [[MutationData alloc]init];
            [mutation createIncrementalSnapshotRecords:wireframes lastWireframes:self.lastSRWireframes];
            // 3.3.2.If exception occurs during incremental judgment, don't do incremental processing, add a FullSnapshotRecord
            if(mutation.isError){
                FTSRFullSnapshotRecord *fullRecord = [[FTSRFullSnapshotRecord alloc]initWithTimestamp:[viewTreeSnapshot.context.date ft_millisecondTimeStamp]];
                fullRecord.wireframes = wireframes;
                [records addObject:fullRecord];
            }else if(!mutation.isEmpty){
                FTSRIncrementalSnapshotRecord *mutationRecord = [[FTSRIncrementalSnapshotRecord alloc]initWithData:mutation timestamp:[viewTreeSnapshot.date ft_millisecondTimeStamp]];
                [records addObject:mutationRecord];
            }
            // 3.3.3.Whether page size changes, landscape/portrait switching
            if(FTCGSizeAspectRatio(self.lastSnapshot.viewportSize) != FTCGSizeAspectRatio(viewTreeSnapshot.viewportSize)){
                ViewportResizeData *viewport = [[ViewportResizeData alloc]initWithViewportSize:viewTreeSnapshot.viewportSize];
                FTSRIncrementalSnapshotRecord *viewportRecord = [[FTSRIncrementalSnapshotRecord alloc]initWithData:viewport timestamp:[viewTreeSnapshot.date ft_millisecondTimeStamp]];
                [records addObject:viewportRecord];
            }
        }
        // 4.Treat touches as incremental addition
        if (touchSnapshot!=nil){
            for (FTTouchCircle *touch in touchSnapshot.touches) {
                PointerInteractionData *pointer = [[PointerInteractionData alloc]initWithTouch:touch];
                FTSRIncrementalSnapshotRecord *pointerRecord = [[FTSRIncrementalSnapshotRecord alloc]initWithData:pointer timestamp:touchSnapshot.timestamp];
                [records addObject:pointerRecord];
            }
        }
        // 5.Data writing
        if(records.count>0){
            FTEnrichedRecord *fullRecord = [[FTEnrichedRecord alloc]initWithContext:viewTreeSnapshot.context records:records];
            // 5.1. Synchronize page collection status to RUM-View
            [self trackRecord:fullRecord];
            // 5.2. Write data to file
            NSData *data = [fullRecord toJSONData];
            if(data){
                [self.writer write:data forceNewFile:force];
                // 6.Record current data for comparison with next data
                self.lastSnapshot = viewTreeSnapshot;
                self.lastSRWireframes = wireframes;
            }else{
                self.lastSRWireframes = nil;
                FTInnerLogError(@"[Session Replay] Snapshot Records to Json Data error");
            }
        }
    } @catch (NSException *exception) {
        self.lastSRWireframes = nil;
        FTInnerLogError(@"[Session Replay] EXCEPTION: %@", exception.description);
    }
}
- (void)changeWriter:(id<FTWriter>)writer needUpdateFullSnapshot:(BOOL)update{
    _writer = writer;
    _needUpdateFullSnapshot = update;
}
- (void)trackRecord:(FTEnrichedRecord *)record{
    NSString *key = record.viewID;
    NSDictionary *existingValue = [self.recordsCountByViewID valueForKey:key];
    NSUInteger count = record.records.count;
    if(existingValue!=nil){
        count = [existingValue[FT_RECORDS_COUNT] integerValue] + count;
    }
    self.recordsCountByViewID[key] = @{
        FT_RECORDS_COUNT:@(count),
    };
    // TODO: Whether to use protocol delegate to replace singleton
    [[FTModuleManager sharedInstance] postMessage:FTMessageKeyRecordsCountByViewID message:[self.recordsCountByViewID mutableCopy]];
}
- (BOOL)isTimeForFullSnapshot{
    if(self.needUpdateFullSnapshot){
        CFTimeInterval currentTime = CACurrentMediaTime();
        if (currentTime - self.lastSnapshotTimestamp >= kFullSnapshotInterval) {
            self.lastSnapshotTimestamp = currentTime;
            return YES;
        }
    }
    return NO;
}

@end
