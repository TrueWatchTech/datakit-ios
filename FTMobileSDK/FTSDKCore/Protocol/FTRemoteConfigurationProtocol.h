//
//  FTRemoteConfigurationProtocol.h
//  FTMobileSDK
//
//  Created by hulilei on 2025/6/5.
//  Copyright © 2025 TRUEWATCH. All rights reserved.
//

#ifndef FTRemoteConfigurationProtocol_h
#define FTRemoteConfigurationProtocol_h

NS_ASSUME_NONNULL_BEGIN

@protocol FTRemoteConfigurationProtocol <NSObject>

- (void)updateRemoteConfiguration:(nullable NSDictionary *)configuration;

@end

@protocol FTRemoteConfigurationDataSource <NSObject>

- (nullable NSDictionary *)getLocalRemoteConfig;

@end

NS_ASSUME_NONNULL_END
#endif /* FTRemoteConfigurationProtocol_h */
