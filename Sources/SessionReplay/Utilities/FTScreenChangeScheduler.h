//
//  FTScreenChangeScheduler.h
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
#import "FTTimerScheduler.h"
#import "FTScheduler.h"
NS_ASSUME_NONNULL_BEGIN

@interface FTScreenChangeScheduler : NSObject<FTScheduler>

@property (nonatomic, assign, readonly) NSTimeInterval minimumInterval;

@property (nonatomic, strong, readonly) id<FTTimerScheduler> timerScheduler;


- (instancetype)initWithMinimumInterval:(NSTimeInterval)minimumInterval
                         timerScheduler:(id<FTTimerScheduler>)timerScheduler;


- (instancetype)initWithMinimumInterval:(NSTimeInterval)minimumInterval;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

#endif
