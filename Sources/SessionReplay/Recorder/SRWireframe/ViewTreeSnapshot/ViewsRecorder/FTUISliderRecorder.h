//
//  FTUISliderRecorder.h
//  SessionReplay
//
//  Created by hulilei on 2023/8/28.
//
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FTSRNodeWireframesBuilder.h"

@class FTViewAttributes, FTSRColorSnapshot;
NS_ASSUME_NONNULL_BEGIN
@interface FTUISliderBuilder : NSObject<FTSRNodeWireframesBuilder>
@property (nonatomic, strong) FTViewAttributes *attributes;
@property (nonatomic, assign) CGRect wireframeRect;

@property (nonatomic, assign) int backgroundWireframeID;
@property (nonatomic, assign) int minTrackWireframeID;
@property (nonatomic, assign) int maxTrackWireframeID;
@property (nonatomic, assign) int thumbWireframeID;

@property (nonatomic, assign) BOOL isEnabled;
@property (nonatomic, assign) BOOL isMasked;

@property (nonatomic, assign) float min;
@property (nonatomic, assign) float max;
@property (nonatomic, assign) float value;

@property (nonatomic, strong, nullable) FTSRColorSnapshot *minTrackTintColor;
@property (nonatomic, strong, nullable) FTSRColorSnapshot *maxTrackTintColor;
@property (nonatomic, strong, nullable) FTSRColorSnapshot *thumbTintColor;

@end
@interface FTUISliderRecorder : NSObject<FTSRWireframesRecorder>
@property (nonatomic, copy) NSString *identifier;

@end

NS_ASSUME_NONNULL_END

#endif
