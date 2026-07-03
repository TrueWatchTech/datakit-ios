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
//  FTQueue.m
//  FTMobileSDK
//
//  Created by hulilei on 2026/3/2.
//

#import "FTQueue.h"
#import "FTSessionReplayCoreImports.h"

@interface FTAsyncQueue()
@end
@implementation FTAsyncQueue 

- (instancetype)initWithQueue:(dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        _queue = queue;
    }
    return self;
}

- (void)run:(void (^)(void))block {
    if (!block) return;
    dispatch_async(_queue, block);
}

@end


@implementation FTBackgroundAsyncQueue

- (instancetype)initWithLabel:(NSString *)label {
    return [self initWithLabel:label
                          qos:QOS_CLASS_UTILITY
                   attributes:dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_UTILITY, 0)
         autoreleaseFrequency:DISPATCH_AUTORELEASE_FREQUENCY_WORK_ITEM
                       target:nil];
}

- (instancetype)initWithLabel:(NSString *)label
                          qos:(qos_class_t)qos
                   attributes:(dispatch_queue_attr_t)attributes
         autoreleaseFrequency:(dispatch_autorelease_frequency_t)autoreleaseFrequency
                       target:(nullable FTAsyncQueue *)target {
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(attributes, qos, 0);
    attr = dispatch_queue_attr_make_with_autorelease_frequency(attr, autoreleaseFrequency);
    
    dispatch_queue_t queue = dispatch_queue_create([label UTF8String], attr);
    if (target) {
        dispatch_set_target_queue(queue, target.queue);
    }
    
    return [super initWithQueue:queue];
}

@end

@implementation FTMainQueue

- (void)run:(void (^)(void))block {
    if (!block) return;
    [FTThreadDispatchManager performBlockDispatchMainAsync:^{
        block();
    }];
}

@end

#endif
