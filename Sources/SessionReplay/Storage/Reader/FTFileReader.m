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
//  FTFileReader.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/26.
//

#import "FTFileReader.h"
#import "FTFilesOrchestrator.h"
#import "FTFile.h"
#import "FTTLVReader.h"
#import "FTPerformancePreset.h"
@interface FTFileReader ()
@property (nonatomic, strong) id<FTFilesOrchestratorType> orchestrator;
@property (nonatomic, strong) NSMutableSet *filesRead;
@end
@implementation FTFileReader
- (instancetype)initWithOrchestrator:(id<FTFilesOrchestratorType>)orchestrator{
    self = [super init];
    if(self){
        _orchestrator = orchestrator;
    }
    return self;
}
- (void)markBatchAsRead:(nonnull FTBatch *)batch {
    [self.orchestrator deleteReadableFile:batch.file];
    [self.filesRead addObject:batch.file.name];
}

- (nullable FTBatch *)readBatch:(nonnull id<FTReadableFile>)file { 
    FTTLVReader *reader = [[FTTLVReader alloc]initWithStream:file.stream maxDataLength:self.orchestrator.performance.maxObjectSize];
    NSArray *datas = [reader all];
    if(datas.count == 0){
        return nil;
    }
    return [[FTBatch alloc]initWithFile:file datas:datas];
}

- (nonnull NSArray<id<FTReadableFile>> *)readFiles:(int)limit { 
    return [self.orchestrator getReadableFiles:self.filesRead limit:limit];
}

@end

#endif
