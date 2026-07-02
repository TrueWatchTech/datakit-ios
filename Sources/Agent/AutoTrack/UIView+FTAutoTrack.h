//
//  UIView+FTAutoTrack.h
//  FTAutoTrack
//
//  Created by hulilei on 2019/11/29.
//  Copyright © 2019 hll. All rights reserved.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#import "FTAutoTrackProperty.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIView (FTAutoTrack)<FTRUMActionProperty>

@end

NS_ASSUME_NONNULL_END
#endif
