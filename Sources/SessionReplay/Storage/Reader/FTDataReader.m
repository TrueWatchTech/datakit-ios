//  Copyright 2024 Shanghai Guance Information Technology Co., Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS
//
//  FTDataReader.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/21.
//

#import "FTDataReader.h"
#import "FTSessionReplayCoreImports.h"
@interface FTDataReader()
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) id<FTReader> fileReader;
@end
@implementation FTDataReader
-(instancetype)initWithQueue:(dispatch_queue_t)queue fileReader:(id<FTReader>)fileReader{
    self = [super init];
    if(self){
        _queue = queue;
        _fileReader = fileReader;
    }
    return self;
}
- (void)markBatchAsRead:(nonnull FTBatch *)batch {
    dispatch_sync(self.queue, ^{
        @try {
            [self.fileReader markBatchAsRead:batch];
        } @catch (NSException *exception) {
            FTInnerLogError(@"[Session Replay] EXCEPTION: %@", exception.description);
        }
    });
}
- (nullable FTBatch *)readBatch:(nonnull id<FTReadableFile>)file { 
    __block FTBatch *batch;
    dispatch_sync(self.queue, ^{
        @try {
            batch = [self.fileReader readBatch:file];
        } @catch (NSException *exception) {
            FTInnerLogError(@"[Session Replay] EXCEPTION: %@", exception.description);
        }
    });
    return batch;
}

- (nonnull NSArray<id<FTReadableFile>> *)readFiles:(int)limit { 
    __block NSArray *files;
    dispatch_sync(self.queue, ^{
        files = [self.fileReader readFiles:limit];
    });
    return files;
}

@end

#endif
