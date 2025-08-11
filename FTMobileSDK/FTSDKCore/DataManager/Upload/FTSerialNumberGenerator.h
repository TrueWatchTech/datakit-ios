//
//  FTSerialNumberGenerator.h
//  FTMobileSDK
//
//  Created by hulilei on 2025/3/12.
//  Copyright © 2025 TRUEWATCH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FTSerialNumberGenerator : NSObject
@property (nonatomic, copy) NSString *prefix;
-(instancetype)initWithPrefix:(NSString *)prefix;
- (NSString *)getCurrentSerialNumber;
- (void)increaseRequestSerialNumber;
@end

NS_ASSUME_NONNULL_END
