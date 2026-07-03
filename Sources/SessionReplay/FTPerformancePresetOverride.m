//
//  FTPerformancePresetOverride.m
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

#import "FTPerformancePresetOverride.h"

@implementation FTPerformancePresetOverride
-(instancetype)init{
    self = [super init];
    if(self){
        _maxFileSize = -1;
        _maxObjectSize = -1;
        _maxObjectsInFile = -1;
        
        _maxFileAgeForWrite = -1;
        _minFileAgeForRead = -1;
        
        _initialUploadDelay = -1;
        _minUploadDelay = -1;
        _maxUploadDelay = -1;
        _uploadDelayChangeRate = -1;
    }
    return self;
}
-(instancetype)initWithMeanFileAge:(NSTimeInterval)meanFileAge minUploadDelay:(NSTimeInterval)minUploadDelay{
    self = [self init];
    _maxFileAgeForWrite = meanFileAge * 0.95;
    _minFileAgeForRead = meanFileAge * 1.05;
    _minUploadDelay = minUploadDelay;
    _maxUploadDelay = minUploadDelay * 10;
    return self;
}
@end

#endif
