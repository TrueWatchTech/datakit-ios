//
//  FTSystemColors.m
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

#import "FTSystemColors.h"
#import "FTSRUtils.h"

#import <UIKit/UIKit.h>
@implementation FTSystemColors
/// The track of a slider.
+ (NSString *)systemFillColorStr{
    if (@available(iOS 13.0, *)) {
        return [FTSRUtils colorHexString:[UIColor systemFillColor].CGColor];
    } else {
        return @"#78788033";
    }
}
/// The background of a switch.
+ (NSString *)secondarySystemFillColorStr{
    if (@available(iOS 13.0, *)) {
        return [FTSRUtils colorHexString:[UIColor secondarySystemFillColor].CGColor];
    } else {
        return @"#78788029";
    }
}
/// Input fields, search bars, buttons.
+ (NSString *)tertiarySystemFillColorStr{
    if (@available(iOS 13.0, *)) {
        return [FTSRUtils colorHexString:[UIColor tertiarySystemFillColor].CGColor];
    } else {
        return @"#7676801F";
    }
}
+ (NSString *)tertiarySystemBackgroundColorStr{
    if (@available(iOS 13.0, *)) {
        return [FTSRUtils colorHexString:[UIColor tertiarySystemBackgroundColor].CGColor];
    } else {
        return @"#FFFFFFFF";
    }
}
+ (NSString *)secondarySystemGroupedBackgroundColorStr{
    if (@available(iOS 13.0, *)) {
        return [FTSRUtils colorHexString:[UIColor secondarySystemGroupedBackgroundColor].CGColor];
    } else {
        return @"#FFFFFFFF";
    }
}
+ (UIColor *)systemBackground{
    if (@available(iOS 13.0, *)) {
        return [UIColor systemBackgroundColor];
    } else {
        return [UIColor colorWithRed:255 / 255 green:255 / 255 blue:255 / 255 alpha:1];
    }
}
+ (NSString *)systemBackgroundColorStr{
    return [FTSRUtils colorHexString:self.systemBackground.CGColor];
}
+ (UIColor *)labelColor{
    if (@available(iOS 13.0, *)) {
        return [UIColor labelColor];
    }else{
        return [UIColor colorWithRed:0/ 255 green:0 / 255 blue:0 / 255 alpha:1];
    }
}
+ (NSString *)labelColorStr{
    return [FTSRUtils colorHexString:[self labelColor].CGColor];
}
+ (NSString *)placeholderTextColorStr{
    if (@available(iOS 13.0, *)) {
        return [FTSRUtils colorHexString:[UIColor placeholderTextColor].CGColor];
    } else {
        return @"#3C3C434C";
    }
}
+ (NSString *)tintColorStr{
    if (@available(iOS 15.0, *)) {
        return [FTSRUtils colorHexString:[UIColor tintColor].CGColor];
    } else {
        return @"#007AFFFF";
    }
}
+ (NSString *)systemGreenColorStr{
    return [FTSRUtils colorHexString:[UIColor systemGreenColor].CGColor];
}
+ (NSString *)clearColorStr{
    return [FTSRUtils colorHexString:[UIColor clearColor].CGColor];
}
@end

#endif
