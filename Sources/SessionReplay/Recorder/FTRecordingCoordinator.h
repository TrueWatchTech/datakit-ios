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
//
//  FTRecordingCoordinator.h
//  FTMobileSDK
//
//  Created by hulilei on 2026/6/4.
//

#import <Foundation/Foundation.h>
#import "FTFeatureStorage.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FTRecordingSampleState) {
    FTRecordingSampleStateNormal,
    FTRecordingSampleStateError,
    FTRecordingSampleStateNone
};

@class FTRecorder, FTSessionReplayConfig, FTSessionReplayTouches;
@protocol FTScheduler;

typedef void (^FTTrackingConsentChanged)(FTTrackingConsent trackingConsent);

@interface FTRecordingCoordinator : NSObject

@property (nonatomic, strong, nullable) FTRecorder *recorder;
@property (nonatomic, strong) id<FTScheduler> scheduler;
@property (atomic, strong, readonly, nullable) NSDictionary *currentRUMContext;
@property (nonatomic, assign, readonly) FTRecordingSampleState sampleState;
@property (nonatomic, assign, readonly) FTTrackingConsent trackingConsent;

- (instancetype)initWithConfig:(FTSessionReplayConfig *)config
               processorsQueue:(dispatch_queue_t)processorsQueue
                     scheduler:(id<FTScheduler>)scheduler
                       touches:(FTSessionReplayTouches *)touches
      trackingConsentDidChange:(nullable FTTrackingConsentChanged)trackingConsentDidChange;

- (void)startRecording;
- (void)handleRUMContextMessage:(NSDictionary *)message;
- (void)handleSampleRateUpdate;
- (void)setSampleState:(FTRecordingSampleState)sampleState;
- (void)evaluateRecordingConditions;

@end

NS_ASSUME_NONNULL_END

#endif
