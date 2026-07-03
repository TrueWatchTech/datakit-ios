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
//  UIView+FTSRPrivacy.h
//  FTMobileSDK
//
//  Created by hulilei on 2025/3/11.
//

#import <UIKit/UIKit.h>
#import "FTSessionReplayPrivacyOverrides.h"

NS_ASSUME_NONNULL_BEGIN

/// Provide access to FTSessionReplayPrivacyOverrides for any UIView
@interface UIView (FTSRPrivacy)

/// UIView manages session replay privacy override settings
/// Usage example:
/// swift: `myView.sessionReplayPrivacyOverrides.textAndInputPrivacy = .maskAll`
/// oc: `myView.sessionReplayPrivacyOverrides.textAndInputPrivacy = FTTextAndInputPrivacyLevelMaskAll`
@property (nonatomic, strong, readonly) FTSessionReplayPrivacyOverrides *sessionReplayPrivacyOverrides;
@end

NS_ASSUME_NONNULL_END

#endif
