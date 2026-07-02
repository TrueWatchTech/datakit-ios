#import <TargetConditionals.h>
#if TARGET_OS_IOS
//
//  FTFileReader.h
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/26.
//  Copyright © 2024 DataFlux-cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTReader.h"
NS_ASSUME_NONNULL_BEGIN
@protocol FTFilesOrchestratorType;
@interface FTFileReader : NSObject<FTReader>
- (instancetype)initWithOrchestrator:(id<FTFilesOrchestratorType>)orchestrator;
@end

NS_ASSUME_NONNULL_END

#endif
