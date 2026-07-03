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
//  FTFeatureScope.m
//  FTMobileSDK
//
//  Created by hulilei on 2026/6/4.
//

#import "FTFeatureScope.h"

@interface FTFeatureContext()
@property (nonatomic, assign, readwrite) FTTrackingConsent trackingConsent;
@end

@implementation FTFeatureContext

- (instancetype)initWithTrackingConsent:(FTTrackingConsent)trackingConsent{
    self = [super init];
    if (self) {
        _trackingConsent = trackingConsent;
    }
    return self;
}

@end

@interface FTFeatureScope()
@property (nonatomic, strong) FTFeatureStorage *storage;
@property (nonatomic, copy) FTTrackingConsentProvider trackingConsentProvider;
@end

@implementation FTFeatureScope

- (instancetype)initWithStorage:(FTFeatureStorage *)storage
        trackingConsentProvider:(FTTrackingConsentProvider)trackingConsentProvider{
    self = [super init];
    if(self){
        _storage = storage;
        _trackingConsentProvider = [trackingConsentProvider copy];
    }
    return self;
}

- (FTTrackingConsent)trackingConsent{
    if (self.trackingConsentProvider) {
        return self.trackingConsentProvider();
    }
    return FTTrackingConsentNotGranted;
}

- (BOOL)isErrorSampled{
    return self.trackingConsent == FTTrackingConsentErrorSampled;
}

- (void)updateTrackingConsent{
    FTFeatureContext *context;
    @synchronized (self) {
        context = [self featureContext];
    }
    [self.storage updateTrackingConsent:context.trackingConsent];
}

- (void)eventWriteContext:(FTFeatureWriteContext)block{
    if (!block) {
        return;
    }
    FTFeatureContext *context;
    id<FTWriter> writer;
    @synchronized (self) {
        context = [self featureContext];
        writer = [self.storage writerForTrackingConsent:context.trackingConsent];
    }
    block(context, writer);
}

- (void)webViewEventWriteContext:(FTFeatureWriteContext)block{
    if (!block) {
        return;
    }
    FTFeatureContext *context;
    id<FTWriter> writer;
    @synchronized (self) {
        context = [self featureContext];
        writer = [self.storage webViewWriterForTrackingConsent:context.trackingConsent];
    }
    block(context, writer);
}

- (FTFeatureContext *)featureContext{
    return [[FTFeatureContext alloc]initWithTrackingConsent:self.trackingConsent];
}

@end

#endif
