//
//  UIView+FTSRPrivacy.m
//  SessionReplay
//
//  Created by hulilei on 2025/3/11.
//
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

#import "UIView+FTSRPrivacy.h"
#import <objc/runtime.h>
static char *associatedOverridesKey = "associatedOverridesKey";

@implementation UIView (FTSRPrivacy)

-(FTSessionReplayPrivacyOverrides *)sessionReplayPrivacyOverrides{
    FTSessionReplayPrivacyOverrides *overrides = [self _privacyOverrides];
    if(overrides){
        return overrides;
    }
    overrides = [FTSessionReplayPrivacyOverrides new];
    objc_setAssociatedObject(self, &associatedOverridesKey, overrides, OBJC_ASSOCIATION_RETAIN);
    return overrides;
}

- (FTSessionReplayPrivacyOverrides *)_privacyOverrides{
    return objc_getAssociatedObject(self, &associatedOverridesKey);
}
@end

#endif
