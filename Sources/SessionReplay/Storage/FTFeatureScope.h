//
//  FTFeatureScope.h
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

#import <Foundation/Foundation.h>
#import "FTFeatureStorage.h"

NS_ASSUME_NONNULL_BEGIN

typedef FTTrackingConsent (^FTTrackingConsentProvider)(void);

@interface FTFeatureContext : NSObject
@property (nonatomic, assign, readonly) FTTrackingConsent trackingConsent;

- (instancetype)initWithTrackingConsent:(FTTrackingConsent)trackingConsent;

@end

typedef void (^FTFeatureWriteContext)(FTFeatureContext *context, id<FTWriter> writer);

@interface FTFeatureScope : NSObject
@property (nonatomic, assign, readonly) FTTrackingConsent trackingConsent;
@property (nonatomic, assign, readonly) BOOL isErrorSampled;

- (instancetype)initWithStorage:(FTFeatureStorage *)storage
        trackingConsentProvider:(FTTrackingConsentProvider)trackingConsentProvider;
- (void)updateTrackingConsent;
- (void)eventWriteContext:(FTFeatureWriteContext)block;
- (void)webViewEventWriteContext:(FTFeatureWriteContext)block;

@end

NS_ASSUME_NONNULL_END

#endif
