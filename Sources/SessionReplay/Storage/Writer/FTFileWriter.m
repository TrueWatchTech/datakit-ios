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
//  FTFileWriter.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/25.
//

#import "FTFileWriter.h"
#import "FTFilesOrchestrator.h"
#import "FTTLV.h"
#import "FTFile.h"
#import "FTSRBaseFrame.h"
#import "FTSessionReplayCoreImports.h"
@interface FTFileWriter()
@property (nonatomic, strong) id<FTFilesOrchestratorType> orchestrator;
@property (nonatomic, strong) dispatch_queue_t queue;
@end
@implementation FTFileWriter
-(instancetype)initWithOrchestrator:(id<FTFilesOrchestratorType>)orchestrator queue:(dispatch_queue_t)queue{
    self = [super init];
    if(self){
        _orchestrator = orchestrator;
        _queue = queue;
    }
    return self;
}
-(void)write:(NSData *)datas{
    [self write:datas forceNewFile:NO];
}
- (void)write:(NSData *)datas forceNewFile:(BOOL)force{
    dispatch_async(self.queue, ^{
        @try {
            NSData *data = datas;
            FTTLV *tlv = [[FTTLV alloc]initWithType:1 value:data];
            data = [tlv serialize];
            long long fileSize = data.length;
            id<FTWritableFile> file = [self.orchestrator getWritableFile:fileSize forceNewFile:force];
            [file append:data];
        } @catch (NSException *exception) {
            FTInnerLogError(@"[Session Replay] EXCEPTION: %@", exception.description);
        }
    });
}
@end

#endif
