//
//  UIGestureRecognizer+FTAutoTrack.h
//  FTMobileAgent
//
//  Created by hulilei on 2021/7/21.
//  Copyright © 2021 hll. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITapGestureRecognizer (FTAutoTrack)
-(instancetype)ft_initWithTarget:(id)target action:(SEL)action;
- (void)ft_addTarget:(id)target action:(SEL)action;
@end

@interface UILongPressGestureRecognizer (FTAutoTrack)
-(instancetype)ft_initWithTarget:(id)target action:(SEL)action;
- (void)ft_addTarget:(id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
#endif
