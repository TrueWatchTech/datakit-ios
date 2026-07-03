//
//  FTTimerScheduler.h
//  SessionReplay
//
//  Created by hulilei on 2026/3/3.
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
NS_ASSUME_NONNULL_BEGIN
@protocol FTScheduledTimer <NSObject>
- (void)cancel;
@end

@protocol FTTimeSource <NSObject>
@property (nonatomic, assign, readonly) NSTimeInterval now;
@end

@protocol FTTimerScheduler <FTTimeSource>

- (id<FTScheduledTimer>)scheduleAfterInterval:(NSTimeInterval)interval action:(dispatch_block_t)action;

@end



@interface FTDispatchSourceScheduledTimer : NSObject <FTScheduledTimer>

- (instancetype)initWithDispatchSourceTimer:(dispatch_source_t)timer;

@end

@interface FTDispatchSourceTimerScheduler : NSObject <FTTimerScheduler>

@property (nonatomic, strong, readonly) dispatch_queue_t queue;

- (instancetype)initWithQueue:(dispatch_queue_t)queue;

+ (instancetype)scheduler;

@property (class, nonatomic, readonly) FTDispatchSourceTimerScheduler *dispatchSource;
@end

NS_ASSUME_NONNULL_END

#endif
