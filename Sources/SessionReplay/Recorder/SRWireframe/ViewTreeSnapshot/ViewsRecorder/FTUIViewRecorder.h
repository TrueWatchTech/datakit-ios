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
//  FTUIViewRecorder.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/8/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FTSRNodeWireframesBuilder.h"

@class FTViewAttributes;
NS_ASSUME_NONNULL_BEGIN

@interface FTUIViewBuilder : NSObject<FTSRNodeWireframesBuilder>
@property (nonatomic, assign) int64_t wireframeID;
@property (nonatomic, strong) FTViewAttributes *attributes;
@end
@interface FTUIViewRecorder : NSObject<FTSRWireframesRecorder>
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) SemanticsOverride semanticsOverride;
-(instancetype)initWithIdentifier:(NSString *)identifier;
-(instancetype)initWithIdentifier:(NSString *)identifier semanticsOverride:(SemanticsOverride)semanticsOverride;
@end

NS_ASSUME_NONNULL_END

#endif
