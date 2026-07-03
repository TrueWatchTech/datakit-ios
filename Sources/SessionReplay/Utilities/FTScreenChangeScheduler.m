//
//  FTScreenChangeScheduler.m
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

#import "FTScreenChangeScheduler.h"
#import "FTQueue.h"
#import "FTScreenChangeMonitor.h"
@interface FTScreenChangeScheduler()
@property (nonatomic, strong) id<FTQueue> queue;
@property (nonatomic, assign) NSTimeInterval minimumInterval;
@property (nonatomic, strong) FTScreenChangeMonitor *monitor;
@property (nonatomic, strong) NSMutableArray<dispatch_block_t> *operations;

@end

@implementation FTScreenChangeScheduler
- (instancetype)initWithMinimumInterval:(NSTimeInterval)minimumInterval
                         timerScheduler:(id<FTTimerScheduler>)timerScheduler {
    if (self = [super init]) {
        _minimumInterval = minimumInterval;
        _timerScheduler = timerScheduler ?: FTDispatchSourceTimerScheduler.dispatchSource;
        _queue = [[FTMainQueue alloc] init];
        _operations = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithMinimumInterval:(NSTimeInterval)minimumInterval{
    return [self initWithMinimumInterval:minimumInterval
                         timerScheduler:FTDispatchSourceTimerScheduler.dispatchSource];
}

#pragma mark - Scheduler
- (void)scheduleWithOperation:(dispatch_block_t)operation {
    if (!operation) {
        return;
    }
    [self.queue run:^{
        [self.operations addObject:[operation copy]];
    }];
}

- (void)start {
    __weak typeof(self) weakSelf = self;
    [self.queue run:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        if (strongSelf.monitor) {
            return;
        }
        
        FTScreenChangeMonitor *monitor = [[FTScreenChangeMonitor alloc] initWithMinimumDeliveryInterval:strongSelf.minimumInterval timerScheduler:strongSelf.timerScheduler handler:^(FTCALayerChangeSnapshot * _Nonnull snapshot) {
            [strongSelf screenDidChange:snapshot];
        }];
        
        if (monitor) {
            [monitor start];
            strongSelf.monitor = monitor;
        } else {
            //
        }
    }];
}

- (void)stop {
    __weak typeof(self) weakSelf = self;
    
    [self.queue run:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf || !strongSelf.monitor) {
            return;
        }
        
        [strongSelf.monitor stop];
        strongSelf.monitor = nil;
    }];
}

- (void)screenDidChange:(FTCALayerChangeSnapshot *)snapshot {
    
    [self.operations enumerateObjectsUsingBlock:^(dispatch_block_t  _Nonnull operation, NSUInteger idx, BOOL * _Nonnull stop) {
        operation();
    }];

}


@end

#endif
