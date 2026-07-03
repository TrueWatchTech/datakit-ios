//
//  FTSRTextObfuscatingFactory.m
//  SessionReplay
//
//  Created by hulilei on 2024/6/12.
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

#import "FTSRTextObfuscatingFactory.h"

@implementation FTSRTextObfuscatingFactory

+ (id<FTSRTextObfuscatingProtocol>)sensitiveTextObfuscator:(TextAndInputPrivacy)privacy{
    return [FTFixLengthMaskObfuscator new];
}
+ (id<FTSRTextObfuscatingProtocol>)inputAndOptionTextObfuscator:(TextAndInputPrivacy)privacy{
    switch (privacy) {
        case FTTextAndInputPrivacyLevelMaskSensitiveInputs:
            return [FTNOPTextObfuscator new];
            break;
        case FTTextAndInputPrivacyLevelMaskAllInputs:
            return [FTFixLengthMaskObfuscator new];
            break;
        case FTTextAndInputPrivacyLevelMaskAll:
            return [FTFixLengthMaskObfuscator new];
            break;
    }
}
+ (id<FTSRTextObfuscatingProtocol>)staticTextObfuscator:(TextAndInputPrivacy)privacy{
    switch (privacy) {
        case FTTextAndInputPrivacyLevelMaskSensitiveInputs:
            return [FTNOPTextObfuscator new];
            break;
        case FTTextAndInputPrivacyLevelMaskAllInputs:
            return [FTNOPTextObfuscator new];
            break;
        case FTTextAndInputPrivacyLevelMaskAll:
            return [FTSpacePreservingMaskObfuscator new];
            break;
    }
}
+ (id<FTSRTextObfuscatingProtocol>)hintTextObfuscator:(TextAndInputPrivacy)privacy{
    switch (privacy) {
        case FTTextAndInputPrivacyLevelMaskSensitiveInputs:
            return [FTNOPTextObfuscator new];
            break;
        case FTTextAndInputPrivacyLevelMaskAllInputs:
            return [FTNOPTextObfuscator new];
            break;
        case FTTextAndInputPrivacyLevelMaskAll:
            return [FTFixLengthMaskObfuscator new];
            break;
    }
}
+ (BOOL)shouldMaskInputElements:(TextAndInputPrivacy)privacy{
    switch (privacy) {
        case FTTextAndInputPrivacyLevelMaskSensitiveInputs:
            return NO;
        case FTTextAndInputPrivacyLevelMaskAllInputs:
        case FTTextAndInputPrivacyLevelMaskAll:
            return YES;
    }
}
@end

@implementation FTFixLengthMaskObfuscator

- (NSString *)mask:(nonnull NSString *)text {
    return @"***";
}

@end

@implementation FTNOPTextObfuscator

- (NSString *)mask:(NSString *)text{
    return text;
}

@end

@implementation FTSpacePreservingMaskObfuscator

-(NSString *)mask:(NSString *)text{
    NSMutableString *masked = [NSMutableString new];
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar ch = [text characterAtIndex:i];
        if (ch == ' ' || ch == '\n' || ch == '\r' || ch == '\t') {
            [masked appendFormat:@"%c",ch];
        } else {
            [masked appendString:@"x"];
        }
    }
    return masked;
}
@end

#endif
