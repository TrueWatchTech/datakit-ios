//
//  FTURLSessionDelegate+Private.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/11/15.
//  Copyright © 2023 TRUEWATCH. All rights reserved.
//

#import "FTURLSessionDelegate.h"
#import "FTURLSessionInterceptorProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface FTURLSessionDelegate ()<FTURLSessionInterceptorProtocol>
@end

NS_ASSUME_NONNULL_END
