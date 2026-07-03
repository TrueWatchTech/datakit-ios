//  Copyright 2024 Shanghai Guance Information Technology Co., Ltd.
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
//  FTTouchSnapshot.h
//  FTMobileSDK
//
//  Created by hulilei on 2024/9/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,FTTouchPhase) {
    TouchDown,
    TouchMoved,
    TouchUp
};

@interface FTTouchCircle : NSObject
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) FTTouchPhase phase;
@property (nonatomic, assign) int identifier;
@property (nonatomic, assign) long long timestamp;
@property (nonatomic, strong ,nullable) NSNumber *touchPrivacyOverride;
@end

@interface FTTouchSnapshot : NSObject

@property (nonatomic, assign) long long timestamp;
@property (nonatomic, strong) NSArray<FTTouchCircle*> *touches;
- (instancetype)initWithTouches:(NSArray<FTTouchCircle*> *)touches;

@end

NS_ASSUME_NONNULL_END

#endif
