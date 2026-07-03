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
//  FTUIImageViewRecorder.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/8/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FTSRNodeWireframesBuilder.h"
@class FTViewAttributes,FTUIImageResource;

NS_ASSUME_NONNULL_BEGIN
typedef UIColor* _Nullable(^FTTintColorProvider)(UIImageView *imageView);
typedef BOOL (^FTShouldRecordImagePredicate)(UIImageView *imageView);

@interface FTUIImageViewBuilder : NSObject<FTSRNodeWireframesBuilder>
@property (nonatomic, assign) int wireframeID;
@property (nonatomic, assign) int imageWireframeID;
@property (nonatomic, strong) FTViewAttributes *attributes;
@property (nonatomic, assign) CGRect contentFrame;

@property (nonatomic, strong, nullable) FTUIImageResource *imageResource;
@property (nonatomic, assign) CGRect wireframeRect;
@end
@interface FTUIImageViewRecorder : NSObject<FTSRWireframesRecorder>
@property (nonatomic, copy) SemanticsOverride semanticsOverride;
@property (nonatomic, copy, nullable) FTShouldRecordImagePredicate shouldRecordImagePredicateOverride;
@property (nonatomic, copy) FTTintColorProvider tintColorProvider;

@property (nonatomic, copy) NSString *identifier;
-(instancetype)initWithIdentifier:(NSString *)identifier
                tintColorProvider:(nullable FTTintColorProvider)tintColorProvider
shouldRecordImagePredicateOverride:(nullable FTShouldRecordImagePredicate)shouldRecordImagePredicateOverride;
@end

NS_ASSUME_NONNULL_END

#endif
