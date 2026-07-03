//
//  FTViewAttributes.h
//  SessionReplay
//
//  Created by hulilei on 2023/7/17.
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
#import "FTViewTreeSnapshot.h"
#import <UIKit/UIKit.h>
#import "FTSRViewID.h"
#import "FTSRTextObfuscatingFactory.h"
#import "FTSessionReplayPrivacyOverrides+Extension.h"
NS_ASSUME_NONNULL_BEGIN
@class FTSRColorSnapshot;

@interface FTSRContext : NSObject
@property (nonatomic, assign) FTTextAndInputPrivacyLevel textAndInputPrivacy;
@property (nonatomic, assign) FTImagePrivacyLevel imagePrivacy;
@property (nonatomic, assign) FTTouchPrivacyLevel touchPrivacy;
@property (nonatomic, copy) NSString *applicationID;
@property (nonatomic, copy) NSString *sessionID;
@property (nonatomic, copy) NSString *viewID;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSDictionary *bindInfo;
@end

@interface FTViewAttributes : NSObject
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) CGRect clip;
@property (nonatomic, strong, nullable) FTSRColorSnapshot *backgroundColor;
@property (nonatomic, strong, nullable) FTSRColorSnapshot *layerBorderColor;
@property (nonatomic, assign) CGFloat layerBorderWidth;
@property (nonatomic, assign) CGFloat layerCornerRadius;
@property (nonatomic, assign) CGFloat alpha;
@property (nonatomic, assign) BOOL  isHidden;
@property (nonatomic, assign) BOOL isVisible;
@property (nonatomic, assign) BOOL hasAnyAppearance;
@property (nonatomic, assign) BOOL isTranslucent;
@property (nonatomic, strong, nullable) NSNumber *imagePrivacy;
@property (nonatomic, strong, nullable) NSNumber *textAndInputPrivacy;
@property (nonatomic, assign) BOOL hide;

-(instancetype)initWithView:(UIView *)view frameInRootView:(CGRect)frame clip:(CGRect)clip overrides:(PrivacyOverrides *)overrides;
-(FTTextAndInputPrivacyLevel)resolveTextAndInputPrivacyLevel:(FTSRContext *)context;
-(FTImagePrivacyLevel)resolveImagePrivacyLevel:(FTSRContext *)context;

@end


NS_ASSUME_NONNULL_END

#endif
