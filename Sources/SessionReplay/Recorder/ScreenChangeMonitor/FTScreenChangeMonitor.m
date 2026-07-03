//
//  FTScreenChangeMonitor.m
//  SessionReplay
//
//  Created by hulilei on 2026/3/2.
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

#import "FTScreenChangeMonitor.h"
#import "FTCALayerChangeAggregator.h"
#import "FTTimerScheduler.h"
#import "FTQueue.h"
#import "FTCALayerSwizzler.h"

@interface FTScreenChangeMonitor()
@property (nonatomic, strong) id<FTQueue> queue;
@property (nonatomic, assign) NSTimeInterval minimumInterval;
@property (nonatomic, strong) FTCALayerChangeAggregator *layerChangeAggregator;
@property (nonatomic, strong) FTCALayerSwizzler *layerSwizzler;

@end
@implementation FTScreenChangeMonitor

- (instancetype)initWithMinimumDeliveryInterval:(NSTimeInterval)minimumDeliveryInterval
                                        handler:(void (^)(FTCALayerChangeSnapshot *snapshot))handler{
    return [self initWithMinimumDeliveryInterval:minimumDeliveryInterval timerScheduler:FTDispatchSourceTimerScheduler.dispatchSource handler:handler];
}
- (instancetype)initWithMinimumDeliveryInterval:(NSTimeInterval)minimumDeliveryInterval
                                 timerScheduler:(id<FTTimerScheduler>)timerScheduler
                                        handler:(void (^)(FTCALayerChangeSnapshot *snapshot))handler{
    if (self = [super init]) {
        id<FTTimerScheduler> scheduler = timerScheduler ?: FTDispatchSourceTimerScheduler.dispatchSource;
        self.layerChangeAggregator = [[FTCALayerChangeAggregator alloc] initWithMinimumDeliveryInterval:minimumDeliveryInterval
                                                                                     timerScheduler:scheduler
                                                                                            handler:handler];
        
        
        self.layerSwizzler = [[FTCALayerSwizzler alloc] initWithObserver:self.layerChangeAggregator];
        if (!self.layerSwizzler) {
            self = nil;
            return nil;
        }
    }
    return self;
}

- (void)dealloc {
    [self stop];
    self.layerChangeAggregator = nil;
    self.layerSwizzler = nil;
}

- (void)start {
    [self.layerChangeAggregator start];
    [self.layerSwizzler swizzleIfNeeded];
}

- (void)stop {
    [self.layerChangeAggregator stop];
}

@end

#endif
