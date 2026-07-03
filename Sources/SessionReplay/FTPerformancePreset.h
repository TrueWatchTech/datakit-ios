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
//  FTPerformancePreset.h
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/25.
//

#import <Foundation/Foundation.h>
@class FTPerformancePresetOverride;
NS_ASSUME_NONNULL_BEGIN
@protocol FTStoragePerformancePreset <NSObject>
@property (nonatomic, assign) long long maxFileSize;
@property (nonatomic, assign) long long maxDirectorySize;
@property (nonatomic, assign) NSTimeInterval maxFileAgeForWrite;
@property (nonatomic, assign) NSTimeInterval minFileAgeForRead;
@property (nonatomic, assign) NSTimeInterval maxFileAgeForRead;
@property (nonatomic, assign) int maxObjectsInFile;
@property (nonatomic, assign) long long maxObjectSize;
@end

@protocol FTUploadPerformancePreset <NSObject>

@property (nonatomic, assign) NSTimeInterval initialUploadDelay;
@property (nonatomic, assign) NSTimeInterval minUploadDelay;
@property (nonatomic, assign) NSTimeInterval maxUploadDelay;
@property (nonatomic, assign) double uploadDelayChangeRate;

@end
@interface FTPerformancePreset : NSObject<FTStoragePerformancePreset,FTUploadPerformancePreset>
@property (nonatomic, assign) long long maxFileSize;
@property (nonatomic, assign) long long maxDirectorySize;
@property (nonatomic, assign) NSTimeInterval maxFileAgeForWrite;
@property (nonatomic, assign) NSTimeInterval minFileAgeForRead;
@property (nonatomic, assign) NSTimeInterval maxFileAgeForRead;
@property (nonatomic, assign) int maxObjectsInFile;
@property (nonatomic, assign) long long maxObjectSize;

@property (nonatomic, assign) NSTimeInterval initialUploadDelay;
@property (nonatomic, assign) NSTimeInterval minUploadDelay;
@property (nonatomic, assign) NSTimeInterval maxUploadDelay;
@property (nonatomic, assign) double uploadDelayChangeRate;

-(instancetype)initWithMeanFileAge:(NSTimeInterval)meanFileAge minUploadDelay:(NSTimeInterval)minUploadDelay;
- (FTPerformancePreset *)updateWithOverride:(FTPerformancePresetOverride *)overridePreset;
@end

NS_ASSUME_NONNULL_END

#endif
