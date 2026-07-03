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
//  FTViewAttributes.m
//  FTMobileSDK
//
//  Created by hulilei on 2023/7/17.
//

#import "FTViewAttributes.h"
#import "FTSRUtils.h"
@implementation FTSRContext
@end

@implementation FTViewAttributes
-(instancetype)initWithView:(UIView *)view frameInRootView:(CGRect)frame clip:(CGRect)clip overrides:(PrivacyOverrides *)overrides{
    self = [super init];
    if(self){
        self.frame = frame;
        self.clip = clip;
        self.alpha = view.alpha;
        self.backgroundColor = [FTSRColorSnapshot snapshotWithColor:view.backgroundColor traitCollection:view.traitCollection];
        self.layerBorderColor = [FTSRColorSnapshot snapshotWithCGColor:view.layer.borderColor];
        self.layerBorderWidth = view.layer.borderWidth;
        self.layerCornerRadius = view.layer.cornerRadius;
        self.isHidden = view.isHidden;
        self.imagePrivacy = overrides.nImagePrivacy;
        self.textAndInputPrivacy = overrides.nTextAndInputPrivacy;
        self.hide = overrides.hide;
    }
    return self;
}
-(BOOL)isVisible{
    return  !self.isHidden && self.alpha > 0 && !CGRectEqualToRect(self.frame, CGRectZero) && !CGRectIsEmpty(CGRectIntersection(self.frame, self.clip));
}
-(BOOL)hasAnyAppearance{
    BOOL hasBorderAppearance = self.layerBorderWidth > 0 && self.layerBorderColor.alpha > 0 ;
    
    BOOL hasFillAppearance = self.backgroundColor.alpha > 0 ;
    return self.isVisible && (hasBorderAppearance || hasFillAppearance);
}
-(BOOL)isTranslucent{
    return  !self.isVisible || self.alpha < 1 || self.backgroundColor.alpha < 1;
}
-(FTTextAndInputPrivacyLevel)resolveTextAndInputPrivacyLevel:(FTSRContext *)context{
    if (self.textAndInputPrivacy != nil) {
        return (FTTextAndInputPrivacyLevel)[self.textAndInputPrivacy intValue];
    }
    return context.textAndInputPrivacy;
}
-(FTImagePrivacyLevel)resolveImagePrivacyLevel:(FTSRContext *)context{
    if (self.imagePrivacy != nil) {
        return (FTImagePrivacyLevel)[self.imagePrivacy intValue];
    }
    return context.imagePrivacy;
}
- (instancetype)copyWithZone:(NSZone *)zone {
    FTViewAttributes *attributes = [[[self class] allocWithZone:zone] init];
    attributes.frame = self.frame;
    attributes.clip = self.clip;
    attributes.alpha = self.alpha;
    attributes.backgroundColor = self.backgroundColor;
    attributes.layerBorderColor = self.layerBorderColor;
    attributes.layerBorderWidth = self.layerBorderWidth;
    attributes.layerCornerRadius = self.layerCornerRadius;
    attributes.isHidden = self.isHidden;
    attributes.imagePrivacy = self.imagePrivacy;
    attributes.textAndInputPrivacy = self.textAndInputPrivacy;
    attributes.hide = self.hide;
    return attributes;
}
@end

#endif
