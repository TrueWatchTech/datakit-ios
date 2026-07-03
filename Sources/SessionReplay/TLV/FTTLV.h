//
//  FTTLV.h
//  SessionReplay
//
//  Created by hulilei on 2024/6/24.
//
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

#import <Foundation/Foundation.h>
extern NSUInteger const FT_MAX_DATA_LENGTH;

NS_ASSUME_NONNULL_BEGIN

@interface FTTLV : NSObject
@property (nonatomic, assign) uint16_t type;
@property (nonatomic, strong) NSData *value;
-(instancetype)initWithType:(uint16_t)type value:(NSData *)value;
- (nullable NSData *)serialize;
- (nullable NSData *)serialize:(UInt64)maxLength;
@end

NS_ASSUME_NONNULL_END

#endif
