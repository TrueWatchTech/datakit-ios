#import <TargetConditionals.h>
#if TARGET_OS_IOS
//
//  FTWindowObserver.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/7/17.
//  Copyright © 2023 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface FTWindowObserver : NSObject
@property (nonatomic, strong, nullable) UIWindow *keyWindow;
- (nullable NSArray<UIWindow *>*)windows;
@end

NS_ASSUME_NONNULL_END

#endif
