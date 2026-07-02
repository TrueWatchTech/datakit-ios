//
//  FTDefaultActionTrackingHandler.h
//  FTMobileSDK
//
//  Created by hulilei on 2025/8/6.
//  Copyright © 2025 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV
#import "FTActionTrackingHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface FTDefaultActionTrackingHandler : NSObject<FTUITouchRUMActionsHandler,FTUIPressRUMActionsHandler>

@end

NS_ASSUME_NONNULL_END
#endif
