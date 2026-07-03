//
//  FTUIHostingViewRecorder.h
//  SessionReplay
//
//  Created by hulilei on 2026/4/29.
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
#import <UIKit/UIKit.h>
#import "FTSRNodeWireframesBuilder.h"

@class FTViewAttributes;

NS_ASSUME_NONNULL_BEGIN

@interface FTUIHostingViewBuilder : NSObject<FTSRNodeWireframesBuilder>
@property (nonatomic, assign) int64_t wireframeID;
@property (nonatomic, strong) FTViewAttributes *attributes;
@property (nonatomic, strong, nullable) id recordingBuilder;
@property (nonatomic, strong, nullable) id<FTSRTextObfuscatingProtocol> textObfuscator;
@end

@interface FTUIHostingViewRecorder : NSObject<FTSRWireframesRecorder>
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) SemanticsOverride semanticsOverride;
@property (nonatomic, copy) FTTextObfuscator textObfuscator;

- (instancetype)initWithIdentifier:(NSString *)identifier;
- (instancetype)initWithIdentifier:(NSString *)identifier
                 semanticsOverride:(nullable SemanticsOverride)semanticsOverride
                     textObfuscator:(nullable FTTextObfuscator)textObfuscator;
+ (BOOL)isSwiftUIGraphicsView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END

#endif
