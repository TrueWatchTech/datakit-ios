//
//  FTUploadStatus.h
//  FTMobileSDK
//
//  Created by hulilei on 2026/5/26.
//  Copyright © 2026 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTUploadStatus : NSObject
@property (nonatomic, assign, readonly) BOOL success;
@property (nonatomic, assign, readonly) BOOL needsRetry;
@property (nonatomic, strong, readonly, nullable) NSNumber *responseCode;
@property (nonatomic, strong, readonly, nullable) NSError *error;
@property (nonatomic, assign, readonly) NSUInteger attempt;

+ (instancetype)statusWithHTTPResponse:(nullable NSHTTPURLResponse *)httpResponse
                                 error:(nullable NSError *)error
                        previousStatus:(nullable FTUploadStatus *)previousStatus;

@end

NS_ASSUME_NONNULL_END
