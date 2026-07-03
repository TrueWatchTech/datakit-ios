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
//  FTScheduler.h
//  FTMobileSDK
//
//  Created by hulilei on 2026/3/2.
//
#import <Foundation/Foundation.h>
#import "FTQueue.h"
#ifndef FTScheduler_h
#define FTScheduler_h

@protocol FTScheduler <NSObject>

@required

@property (nonatomic, strong, readonly) id<FTQueue> queue;


- (void)scheduleWithOperation:(void (^)(void))operation;

- (void)start;


- (void)stop;

@end

#endif /* FTScheduler_h */

#endif
