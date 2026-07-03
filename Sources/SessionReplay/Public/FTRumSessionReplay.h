//
//  FTRumSessionReplay.h
//  SessionReplay
//
//  Created by hulilei on 2022/12/23.
//
//  Copyright 2022 Shanghai Guance Information Technology Co., Ltd.
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
#import "FTSessionReplayConfig.h"
NS_ASSUME_NONNULL_BEGIN
@interface FTRumSessionReplay : NSObject

/// Singleton
+ (instancetype)sharedInstance NS_SWIFT_NAME(shared());;

/// Configure Config to enable Session Replay
/// - Parameter config: Session Replay configuration items
- (void)startWithSessionReplayConfig:(FTSessionReplayConfig *)config;
@end

NS_ASSUME_NONNULL_END

#endif
