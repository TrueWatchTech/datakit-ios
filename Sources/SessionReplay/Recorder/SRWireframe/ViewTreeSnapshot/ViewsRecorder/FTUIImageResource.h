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
//  FTUIImageResource.h
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/14.
//

#import <Foundation/Foundation.h>
#import "FTSRNodeWireframesBuilder.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface FTUIImageResource : NSObject<FTSRResource>
-(instancetype)initWithImage:(UIImage *)image tintColor:(UIColor *)tintColor;
-(instancetype)initWithImage:(UIImage *)image tintColor:(nullable UIColor *)tintColor traitCollection:(nullable UITraitCollection *)traitCollection;
@end

NS_ASSUME_NONNULL_END

#endif
