//
//  FTDefaultUIKitViewTrackingHandler.h
//  FTMobileSDK
//
//  Created by hulilei on 2025/8/6.
//  Copyright © 2025 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV
#import "FTViewTrackingHandler.h"

NS_ASSUME_NONNULL_BEGIN
@interface FTDefaultUIKitViewTrackingHandler : NSObject<FTUIKitViewTrackingHandler>

@end

@interface FTDefaultSwiftUIViewTrackingHandler : NSObject<FTSwiftUIViewTrackingHandler>
@end
NS_ASSUME_NONNULL_END
#endif
