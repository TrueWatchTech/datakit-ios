//
//  FTSystemColors.h
//  SessionReplay
//
//  Created by hulilei on 2023/8/28.
//
//  Copyright 2023 Shanghai Guance Information Technology Co., Ltd.
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

NS_ASSUME_NONNULL_BEGIN

@interface FTSystemColors : NSObject
/// The track of a slider.
+ (NSString *)systemFillColorStr;
/// The background of a switch.
+ (NSString *)secondarySystemFillColorStr;
/// Input fields, search bars, buttons.
+ (NSString *)tertiarySystemFillColorStr;
+ (NSString *)tertiarySystemBackgroundColorStr;
+ (NSString *)secondarySystemGroupedBackgroundColorStr;
+ (UIColor *)systemBackground;

+ (NSString *)systemBackgroundColorStr;
+ (UIColor *)labelColor;
+ (NSString *)labelColorStr;
+ (NSString *)placeholderTextColorStr;
+ (NSString *)tintColorStr;
+ (NSString *)systemGreenColorStr;
+ (NSString *)clearColorStr;
@end

NS_ASSUME_NONNULL_END

#endif
