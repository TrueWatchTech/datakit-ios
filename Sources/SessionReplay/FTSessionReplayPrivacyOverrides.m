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
//  FTSessionReplayPrivacyOverrides.m
//  FTMobileSDK
//
//  Created by hulilei on 2025/3/11.
//

#import "FTSessionReplayPrivacyOverrides.h"
#import "FTSessionReplayPrivacyOverrides+Extension.h"

@implementation FTSessionReplayPrivacyOverrides
-(void)setImagePrivacy:(FTImagePrivacyLevelOverride)imagePrivacy{
    _imagePrivacy = imagePrivacy;
    switch (imagePrivacy) {
        case FTImagePrivacyLevelOverrideNone:
            _nImagePrivacy = nil;
            break;
        case FTImagePrivacyLevelOverrideMaskNonBundledOnly:
            _nImagePrivacy = @(FTImagePrivacyLevelMaskNonBundledOnly);
            break;
        case FTImagePrivacyLevelOverrideMaskAll:
            _nImagePrivacy = @(FTImagePrivacyLevelMaskAll);
            break;
        case FTImagePrivacyLevelOverrideMaskNone:
            _nImagePrivacy = @(FTImagePrivacyLevelMaskNone);
            break;
    }
}
-(void)setTouchPrivacy:(FTTouchPrivacyLevelOverride)touchPrivacy{
    _touchPrivacy = touchPrivacy;
    switch (touchPrivacy) {
        case FTTouchPrivacyLevelOverrideNone:
            _nTouchPrivacy = nil;
            break;
        case FTTouchPrivacyLevelOverrideShow:
            _nTouchPrivacy = @(FTTouchPrivacyLevelShow);
            break;
        case FTTouchPrivacyLevelOverrideHide:
            _nTouchPrivacy = @(FTTouchPrivacyLevelHide);
            break;
    }
}
- (void)setTextAndInputPrivacy:(FTTextAndInputPrivacyLevelOverride)textAndInputPrivacy{
    _textAndInputPrivacy = textAndInputPrivacy;
    switch (textAndInputPrivacy) {
        case FTTextAndInputPrivacyLevelOverrideNone:
            _nTextAndInputPrivacy = nil;
            break;
        case FTTextAndInputPrivacyLevelOverrideMaskSensitiveInputs:
            _nTextAndInputPrivacy = @(FTTextAndInputPrivacyLevelMaskSensitiveInputs);
            break;
        case FTTextAndInputPrivacyLevelOverrideMaskAllInputs:
            _nTextAndInputPrivacy = @(FTTextAndInputPrivacyLevelMaskAllInputs);
            break;
        case FTTextAndInputPrivacyLevelOverrideMaskAll:
            _nTextAndInputPrivacy = @(FTTextAndInputPrivacyLevelMaskAll);
            break;
    }
}
+ (PrivacyOverrides *)mergeChild:(PrivacyOverrides *)child parent:(PrivacyOverrides *)parent{
    if (!child) {
        return parent;
    }
    if (!parent) {
        return child;
    }
    child.nTextAndInputPrivacy = child.nTextAndInputPrivacy ?: parent.nTextAndInputPrivacy;
    child.nImagePrivacy = child.nImagePrivacy ?: parent.nImagePrivacy;
    child.nTouchPrivacy = child.nTouchPrivacy ?: parent.nTouchPrivacy;
    if (child.hide == YES || parent.hide == YES) {
        child.hide = YES;
    }
    return child;
}
@end

#endif
