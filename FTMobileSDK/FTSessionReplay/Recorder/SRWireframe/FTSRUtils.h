//
//  FTSRUtils.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/8/8.
//  Copyright © 2023 TRUEWATCH. All rights reserved.
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
@interface FTSRUtils : NSObject
+ (NSString *)colorHexString:(CGColorRef)color;
+ (BOOL)isSensitiveText:(id<UITextInputTraits>)textInputTraits;
+ (nullable CGColorRef)safeCast:(CGColorRef)cgColor;
+ (CGFloat)getCGColorAlpha:(CGColorRef)color;
@end

NS_ASSUME_NONNULL_END
