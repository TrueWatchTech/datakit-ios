//
//  FTResourcesFeature.m
//  SessionReplay
//
//  Created by hulilei on 2024/7/4.
//
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

#import "FTResourcesFeature.h"
#import "FTResourceRequest.h"
#import "FTPerformancePresetOverride.h"
#import "FTTLV.h"
@implementation FTResourcesFeature
-(instancetype)init{
    self = [super init];
    if(self){
        _name = @"session-replay-resources";
        _requestBuilder = [[FTResourceRequest alloc]init];
        FTPerformancePresetOverride *performanceOverride = [[FTPerformancePresetOverride alloc]init];
        performanceOverride.maxObjectSize = FT_MAX_DATA_LENGTH;
        performanceOverride.maxFileSize = FT_MAX_DATA_LENGTH;
        performanceOverride.maxObjectsInFile = 40;
        _performanceOverride = performanceOverride;
    }
    return self;
}
@end

#endif
