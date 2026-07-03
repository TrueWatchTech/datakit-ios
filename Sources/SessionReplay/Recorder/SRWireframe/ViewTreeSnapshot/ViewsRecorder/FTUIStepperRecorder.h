//
//  FTUIStepperRecorder.h
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

@class FTViewAttributes;
NS_ASSUME_NONNULL_BEGIN
@interface FTUIStepperBuilder : NSObject<FTSRNodeWireframesBuilder>
@property (nonatomic, strong) FTViewAttributes *attributes;
@property (nonatomic, assign) int backgroundWireframeID;
@property (nonatomic, assign) int dividerWireframeID;
@property (nonatomic, assign) int minusWireframeID;
@property (nonatomic, assign) int plusHorizontalWireframeID;
@property (nonatomic, assign) int plusVerticalWireframeID;
@property (nonatomic, assign) CGRect wireframeRect;
@property (nonatomic, assign) CGFloat cornerRadius;
/// Whether LeftSegment click is allowed
///  When current value is at minimum, `—` is not clickable, displays gray
///  (14,2)
@property (nonatomic, assign) BOOL isMinusEnabled;
/// Whether RightSegment click is allowed
///  When current value is at maximum, `+` is not clickable, displays gray
///  (14,12)
@property (nonatomic, assign) BOOL isPlusEnabled;
@end
@interface FTUIStepperRecorder : NSObject<FTSRWireframesRecorder>
@property (nonatomic, copy) NSString *identifier;

@end

NS_ASSUME_NONNULL_END

#endif
