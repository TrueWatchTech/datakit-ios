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
//
//  FTSRUtils.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/8/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum FTSRPrivacy:NSUInteger FTSRPrivacy;
typedef NS_ENUM(NSUInteger,HorizontalAlignment){
    HorizontalAlignmentLeft,
    HorizontalAlignmentRight,
    HorizontalAlignmentCenter,
};
typedef NS_ENUM(NSUInteger,VerticalAlignment){
    VerticalAlignmentTop,
    VerticalAlignmentBottom,
    VerticalAlignmentMiddle,
};
NS_ASSUME_NONNULL_BEGIN
CGRect FTCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);
CGRect FTCGRectPutInside(CGRect oriRect, CGRect inRect, HorizontalAlignment horizontal,VerticalAlignment vertical);

CGFloat FTCGSizeAspectRatio(CGSize size);
@interface FTSRColorSnapshot : NSObject
@property (nonatomic, readonly, nullable) CGColorRef cgColor;
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, copy, readonly, nullable) NSString *hexString;
+ (nullable instancetype)snapshotWithColor:(nullable UIColor *)color traitCollection:(nullable UITraitCollection *)traitCollection;
+ (nullable instancetype)snapshotWithCGColor:(nullable CGColorRef)cgColor;
@end

@interface FTSRUtils : NSObject
+ (NSString *)colorHexString:(CGColorRef)color;
+ (BOOL)isSensitiveText:(id<UITextInputTraits>)textInputTraits;
+ (nullable CGColorRef)safeCast:(CGColorRef)cgColor;
+ (CGFloat)getCGColorAlpha:(CGColorRef)color;
+ (nullable NSString *)getTextStyleTruncationMode:(NSLineBreakMode)lineBreakMode;
@end

NS_ASSUME_NONNULL_END

#endif
