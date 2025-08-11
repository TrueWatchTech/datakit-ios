//
//  FTMemoryMonitor.h
//  FTMobileAgent
//
//  Created by hulilei on 2022/7/1.
//  Copyright © 2022 TRUEWATCH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Memory monitor
@interface FTMemoryMonitor : NSObject
/// Memory usage
- (double)memoryUsage;
@end

NS_ASSUME_NONNULL_END
