#import <TargetConditionals.h>
#if TARGET_OS_IOS
//
//  UITouch+FTIdentifier.h
//  FTMobileAgent
//
//  Created by hulilei on 2023/1/12.
//  Copyright © 2023 DataFlux-cn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITouch (FTIdentifier)
@property (nonatomic, strong,nullable) NSNumber *identifier;
@property (nonatomic, strong,nullable) NSNumber *touchPrivacyOverride;

@end

NS_ASSUME_NONNULL_END

#endif
