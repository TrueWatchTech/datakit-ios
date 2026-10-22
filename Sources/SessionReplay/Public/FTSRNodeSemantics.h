//
//  FTSRNodeSemantics.h
//  SessionReplay
//
//  Copyright 2026 TRUEWATCH TECHNOLOGY INC PTE. LTD.
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
#if TARGET_OS_IOS || TARGET_OS_OSX

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NodeSubtreeStrategy) {
    NodeSubtreeStrategyRecord,
    NodeSubtreeStrategyIgnore
};

@protocol FTSRNodeWireframesBuilder;

@interface FTSRNodeSemantics : NSObject
@property (nonatomic, assign) int importance;
@property (nonatomic, strong) NSArray<id<FTSRNodeWireframesBuilder>> *nodes;
@property (nonatomic, assign) NodeSubtreeStrategy subtreeStrategy;
- (instancetype)initWithSubtreeStrategy:(NodeSubtreeStrategy)subtreeStrategy;
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
