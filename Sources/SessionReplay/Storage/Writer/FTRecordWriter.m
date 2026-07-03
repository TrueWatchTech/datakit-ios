//
//  FTRecordWriter.m
//  SessionReplay
//
//  Created by hulilei on 2026/6/4.
//
//  Copyright 2026 Shanghai Guance Information Technology Co., Ltd.
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

#import "FTRecordWriter.h"
#import "FTFileWriter.h"
#import "FTFeatureScope.h"

@interface FTRecordWriter()
@property (nonatomic, strong) FTFeatureScope *featureScope;
@end

@implementation FTRecordWriter

- (instancetype)initWithFeatureScope:(FTFeatureScope *)featureScope{
    self = [super init];
    if(self){
        _featureScope = featureScope;
    }
    return self;
}

- (BOOL)isErrorSampled{
    return self.featureScope.isErrorSampled;
}

- (void)write:(NSData *)data{
    [self write:data forceNewFile:NO];
}

- (void)write:(NSData *)data forceNewFile:(BOOL)force{
    [self.featureScope eventWriteContext:^(__unused FTFeatureContext *context, id<FTWriter> writer) {
        [writer write:data forceNewFile:force];
    }];
}

@end

#endif
