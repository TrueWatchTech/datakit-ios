//  Copyright 2025 Shanghai Guance Information Technology Co., Ltd.
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
//  FTSessionReplayWireframesBuilder.h
//  FTMobileSDK
//
//  Created by hulilei on 2025/4/21.
//

#import <Foundation/Foundation.h>
#import "FTSRNodeWireframesBuilder.h"
NS_ASSUME_NONNULL_BEGIN
@class FTSRWebViewWireframe,FTUIImageResource,FTSRImageWireframe;
@interface FTSessionReplayWireframesBuilder : NSObject
@property (nonatomic, strong) NSMutableArray<id<FTSRResource>> *resources;
-(instancetype)initWithResources:(NSArray<id <FTSRResource>>*)resources webViewSlotIDs:( NSSet<NSNumber *> *)webViewSlotIDs;

- (void)addResources:(NSArray<id <FTSRResource>>*)resources;
- (FTSRWireframe *)createShapeWireframeWithID:(int64_t)identifier attributes:(FTViewAttributes *)attributes;

- (FTSRImageWireframe *)createImageWireframeWithID:(int64_t)identifier resource:(id<FTSRResource>)resource frame:(CGRect)frame clip:(CGRect)clip;

- (FTSRWebViewWireframe *)visibleWebViewWireframeWithID:(int64_t)identifier attributes:(FTViewAttributes *)attributes linkRUMKeysInfo:(nullable NSDictionary *)linkRUMKeysInfo;
- (NSArray<FTSRWireframe*>*)hiddenWebViewWireframes;

- (NSSet<NSNumber *> *)hiddenWebViewSlotIDs;
- (NSDictionary *)linkRumKeysInfo;
@end

NS_ASSUME_NONNULL_END

#endif
