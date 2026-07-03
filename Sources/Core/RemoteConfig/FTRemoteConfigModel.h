//
//  FTRemoteConfigModel.h
//
//  Created by hulilei on 2025/12/23.
//  Copyright 2025 Shanghai Guance Information Technology Co., Ltd.
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTRemoteConfigModel : NSObject

@property (nonatomic, copy, nullable) NSString *env;
@property (nonatomic, copy, nullable) NSString *serviceName;
@property (nonatomic, strong, nullable) NSNumber *autoSync;
@property (nonatomic, strong, nullable) NSNumber *compressIntakeRequests;
@property (nonatomic, strong, nullable) NSNumber *syncPageSize;
@property (nonatomic, strong, nullable) NSNumber *syncSleepTime;

@property (nonatomic, strong, nullable) NSNumber *rumSampleRate;
@property (nonatomic, strong, nullable) NSNumber *rumSessionOnErrorSampleRate;
@property (nonatomic, strong, nullable) NSNumber *rumEnableTraceUserAction;
@property (nonatomic, strong, nullable) NSNumber *rumEnableTraceUserView;
@property (nonatomic, strong, nullable) NSNumber *rumEnableTraceUserResource;
@property (nonatomic, strong, nullable) NSNumber *rumEnableResourceHostIP;
@property (nonatomic, strong, nullable) NSNumber *rumEnableTrackAppUIBlock;
@property (nonatomic, strong, nullable) NSNumber *rumBlockDurationMs;
@property (nonatomic, strong, nullable) NSNumber *rumEnableTrackAppCrash;
@property (nonatomic, strong, nullable) NSNumber *rumEnableTrackAppANR;
@property (nonatomic, strong, nullable) NSNumber *rumEnableTraceWebView;
@property (nonatomic, copy, nullable) NSArray *rumAllowWebViewHost;

@property (nonatomic, strong, nullable) NSNumber *traceSampleRate;
@property (nonatomic, strong, nullable) NSNumber *traceEnableAutoTrace;
@property (nonatomic, copy, nullable) NSString *traceType;

@property (nonatomic, strong, nullable) NSNumber *logSampleRate;
@property (nonatomic, copy, nullable) NSArray *logLevelFilters;
@property (nonatomic, strong, nullable) NSNumber *logEnableCustomLog;

@property (nonatomic, strong, nullable) NSNumber *sessionReplaySampleRate;
@property (nonatomic, strong, nullable) NSNumber *sessionReplayOnErrorSampleRate;

@end

NS_ASSUME_NONNULL_END
