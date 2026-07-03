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
//  UITouch+FTIdentifier.m
//  FTMobileAgent
//
//  Created by hulilei on 2023/1/12.
//

#import "UITouch+FTIdentifier.h"
#import <objc/runtime.h>
static char *touchIdentifier = "FTTouchIdentifier";
static char *kTouchPrivacyOverride = "kTouchPrivacyOverride";

@implementation UITouch (FTIdentifier)
-(void)setIdentifier:(NSNumber*)identifier{
    objc_setAssociatedObject(self, &touchIdentifier, identifier, OBJC_ASSOCIATION_RETAIN);
}
-(NSNumber*)identifier{
    return objc_getAssociatedObject(self, &touchIdentifier);
}
-(void)setTouchPrivacyOverride:(NSNumber *)touchPrivacyOverride{
    objc_setAssociatedObject(self, &kTouchPrivacyOverride, touchPrivacyOverride, OBJC_ASSOCIATION_RETAIN);
}
-(NSNumber *)touchPrivacyOverride{
    return objc_getAssociatedObject(self, &kTouchPrivacyOverride);
}

@end

#endif
