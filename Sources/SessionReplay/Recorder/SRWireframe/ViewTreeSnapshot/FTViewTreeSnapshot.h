//  Copyright 2024 Shanghai Guance Information Technology Co., Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS
//
//  FTViewTreeSnapshot.h
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/13.
//

#import <Foundation/Foundation.h>
#import "FTSessionReplayWireframesBuilder.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger,NodeSubtreeStrategy){
    NodeSubtreeStrategyRecord,
    NodeSubtreeStrategyIgnore
};

@protocol FTSRNodeWireframesBuilder,FTSRResource;
@interface FTSRNodeSemantics : NSObject
@property (nonatomic, assign) int importance;
@property (nonatomic, strong) NSArray<id<FTSRNodeWireframesBuilder>> *nodes;
@property (nonatomic, assign) NodeSubtreeStrategy subtreeStrategy;
-(instancetype)initWithSubtreeStrategy:(NodeSubtreeStrategy)subtreeStrategy;

@end

@protocol FTSRNodeWireframesBuilder;
@protocol FTSRResource;
@class FTSRContext;
@interface FTViewTreeSnapshot : NSObject
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) FTSRContext *context;
@property (nonatomic, assign) CGSize viewportSize;
@property (nonatomic, strong) NSArray<id<FTSRNodeWireframesBuilder>> *nodes;
@property (nonatomic, strong) NSArray<id<FTSRResource>> *resources;
@property (nonatomic, strong) NSSet<NSNumber *>* webViewSlotIDs;
@end

@interface FTSessionReplayNode: NSObject
@property (nonatomic, strong) FTViewAttributes *attributes;
@property (nonatomic, strong) FTSessionReplayWireframesBuilder *builder;
@end

@interface FTUnknownElement : FTSRNodeSemantics
+ (instancetype)constant;
@end
@interface FTInvisibleElement : FTSRNodeSemantics
+ (instancetype)constant;
@end
@interface FTIgnoredElement : FTSRNodeSemantics

@end

@interface FTAmbiguousElement : FTSRNodeSemantics

@end

@interface FTSpecificElement : FTSRNodeSemantics

@end
NS_ASSUME_NONNULL_END

#endif
