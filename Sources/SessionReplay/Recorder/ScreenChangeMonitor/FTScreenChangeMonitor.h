//
//  FTScreenChangeMonitor.h
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

#import <Foundation/Foundation.h>
#import "FTCALayerChangeSnapshot.h"
#import "FTTimerScheduler.h"

NS_ASSUME_NONNULL_BEGIN

@interface FTScreenChangeMonitor : NSObject
- (instancetype)initWithMinimumDeliveryInterval:(NSTimeInterval)minimumDeliveryInterval
                                 timerScheduler:(id<FTTimerScheduler>)timerScheduler
                                        handler:(void (^)(FTCALayerChangeSnapshot *snapshot))handler;

- (instancetype)initWithMinimumDeliveryInterval:(NSTimeInterval)minimumDeliveryInterval
                                        handler:(void (^)(FTCALayerChangeSnapshot *snapshot))handler;
                    

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)start;

- (void)stop;
@end

NS_ASSUME_NONNULL_END

#endif
