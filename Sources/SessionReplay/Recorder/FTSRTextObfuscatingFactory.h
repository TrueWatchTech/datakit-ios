//
//  FTSRTextObfuscatingFactory.h
//  SessionReplay
//
//  Created by hulilei on 2024/6/12.
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
#import "FTRumSessionReplay.h"
typedef FTTextAndInputPrivacyLevel TextAndInputPrivacy;
NS_ASSUME_NONNULL_BEGIN
@protocol FTSRTextObfuscatingProtocol <NSObject>

- (NSString *)mask:(NSString *)text;

@end
@interface FTSRTextObfuscatingFactory : NSObject
+ (id<FTSRTextObfuscatingProtocol>)sensitiveTextObfuscator:(TextAndInputPrivacy)privacy;
+ (id<FTSRTextObfuscatingProtocol>)inputAndOptionTextObfuscator:(TextAndInputPrivacy)privacy;
+ (id<FTSRTextObfuscatingProtocol>)staticTextObfuscator:(TextAndInputPrivacy)privacy;
+ (id<FTSRTextObfuscatingProtocol>)hintTextObfuscator:(TextAndInputPrivacy)privacy;
+ (BOOL)shouldMaskInputElements:(TextAndInputPrivacy)privacy;

@end

@interface FTNOPTextObfuscator : NSObject <FTSRTextObfuscatingProtocol>
@end
@interface FTFixLengthMaskObfuscator : NSObject<FTSRTextObfuscatingProtocol>

@end

@interface FTSpacePreservingMaskObfuscator : NSObject<FTSRTextObfuscatingProtocol>
@end
NS_ASSUME_NONNULL_END

#endif
