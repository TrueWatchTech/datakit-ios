//
//  UIColor+FTSRIdentifier.m
//  SessionReplay
//
//  Created by hulilei on 2024/6/17.
//
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

#import "UIColor+FTSRIdentifier.h"
#import <objc/runtime.h>
static char *srIdentifierKey = "FTSRIdentifierKey";

@implementation UIColor (FTSRIdentifier)
-(void)setSrIdentifier:(NSString *)srIdentifier{
    objc_setAssociatedObject(self, &srIdentifierKey, srIdentifier, OBJC_ASSOCIATION_RETAIN);
}
- (NSString *)srIdentifier{
    NSString *hash = objc_getAssociatedObject(self, &srIdentifierKey);
    if(hash && hash.length>0){
        return hash;
    }
    NSString *newHash = [self computeIdentifier];
    self.srIdentifier = newHash;
    return newHash;
}
- (NSString *)computeIdentifier{
    CGFloat r = 0;
    CGFloat g = 0;
    CGFloat b = 0;
    CGFloat a = 0;
    if (![self getRed:&r green:&g blue:&b alpha:&a]) {
        CGColorRef color = self.CGColor;
        if (color) {
            size_t count = CGColorGetNumberOfComponents(color);
            const CGFloat *components = CGColorGetComponents(color);
            if (count == 2) {
                r = components[0];
                g = components[0];
                b = components[0];
                a = CGColorGetAlpha(color);
            }
        }
    }
    return [NSString stringWithFormat:@"%02X%02X%02X%02X",(int)round(r * 255), (int)round(g * 255), (int)round(b * 255), (int)round(a * 255)];
}
- (UIColor *)ftsr_resolvedColorWithTraitCollection:(nullable UITraitCollection *)traitCollection{
    if (@available(iOS 13.0, *)) {
        return [self resolvedColorWithTraitCollection:traitCollection ?: [UITraitCollection currentTraitCollection]];
    }
    return self;
}
@end

#endif
