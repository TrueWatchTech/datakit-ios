//
//  FTQueue.h
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

NS_ASSUME_NONNULL_BEGIN
@protocol FTQueue <NSObject>

- (void)run:(void (^)(void))block;

@end

@interface FTAsyncQueue : NSObject <FTQueue>

@property (nonatomic, strong) dispatch_queue_t queue;

- (instancetype)initWithQueue:(dispatch_queue_t)queue;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface FTBackgroundAsyncQueue : FTAsyncQueue


- (instancetype)initWithLabel:(NSString *)label
                          qos:(qos_class_t)qos
                   attributes:(dispatch_queue_attr_t)attributes
         autoreleaseFrequency:(dispatch_autorelease_frequency_t)autoreleaseFrequency
                       target:(nullable FTAsyncQueue *)target NS_DESIGNATED_INITIALIZER;


- (instancetype)initWithLabel:(NSString *)label;

- (instancetype)init NS_UNAVAILABLE;

@end

@interface FTMainQueue : NSObject <FTQueue>

@end


NS_ASSUME_NONNULL_END

#endif
