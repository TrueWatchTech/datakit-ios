//  Copyright 2023 Shanghai Guance Information Technology Co., Ltd.
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
//  FTUISegmentRecorder.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/8/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FTSRNodeWireframesBuilder.h"

@class FTViewAttributes, FTSRColorSnapshot;
NS_ASSUME_NONNULL_BEGIN
@interface FTUISegmentBuilder:NSObject<FTSRNodeWireframesBuilder>
@property (nonatomic, assign) CGRect wireframeRect;
@property (nonatomic, assign) int backgroundWireframeID;
@property (nonatomic, strong) FTViewAttributes *attributes;
@property (nonatomic, strong, nullable) NSNumber *selectedSegmentIndex;
@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic, strong) NSArray *segmentWireframeIDs;
@property (nonatomic, strong, nullable) FTSRColorSnapshot *selectedSegmentTintColor;
@property (nonatomic, strong) id<FTSRTextObfuscatingProtocol> textObfuscator;
@end
@interface FTUISegmentRecorder : NSObject<FTSRWireframesRecorder>
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic,copy) FTTextObfuscator textObfuscator;
-(instancetype)initWithIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END

#endif
