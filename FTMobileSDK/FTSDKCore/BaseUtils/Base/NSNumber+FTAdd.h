//
//  NSNumber+FTAdd.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/7/25.
//  Copyright © 2023 TRUEWATCH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (FTAdd)
- (id)ft_toFieldFormat;
- (id)ft_toFieldIntegerCompatibleFormat;

/// Preserve precision for float and double in user custom properties
- (id)ft_toUserFieldFormat;
- (id)ft_toTagFormat;
@end

NS_ASSUME_NONNULL_END
