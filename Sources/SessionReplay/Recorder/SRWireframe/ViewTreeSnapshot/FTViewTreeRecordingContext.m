//
//  FTViewTreeRecordingContext.m
//  SessionReplay
//
//  Created by hulilei on 2024/6/13.
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

#import "FTViewTreeRecordingContext.h"
#import <SafariServices/SafariServices.h>
#import <SwiftUI/SwiftUI.h>
@implementation FTViewTreeRecordingContext
- (instancetype)copyWithZone:(NSZone *)zone {
    FTViewTreeRecordingContext *options = [[[self class] allocWithZone:zone] init];
    options.recorder = self.recorder;
    options.viewIDGenerator = self.viewIDGenerator;
    options.coordinateSpace = self.coordinateSpace;
    options.viewControllerContext = self.viewControllerContext;
    options.clip = self.clip;
    options.webViewCache = self.webViewCache;
    return options;
}
@end
@implementation FTViewControllerContext
- (NSString *)name{
    if(!self.isRootView){
        return nil;
    }
    switch (self.parentType) {
        case ViewControllerTypeAlert:
            return @"Alert";
        case ViewControllerTypeSafari:
            return @"Safari";
        case ViewControllerTypeActivity:
            return @"Activity";
        case ViewControllerTypeSwiftUI:
            return @"SwiftUI";
        case ViewControllerTypeOther:
            return nil;
    }
}
- (BOOL)isRootView:(ViewControllerType)type {
    return self.parentType == type && self.isRootView == YES;
}
- (void)setParentTypeWithViewController:(UIViewController *)viewController{
    if([viewController isKindOfClass:UIAlertController.class]){
        self.parentType = ViewControllerTypeAlert;
    }else if ([viewController isKindOfClass:UIActivityViewController.class]){
        self.parentType = ViewControllerTypeActivity;
    }else if ([viewController isKindOfClass:SFSafariViewController.class]){
        self.parentType = ViewControllerTypeSafari;
    }else if([FTViewControllerContext isSwiftUIViewController:viewController]){
        self.parentType = ViewControllerTypeSwiftUI;
    }else{
        self.parentType = ViewControllerTypeOther;
    }
}
+ (BOOL)isSwiftUIViewController:(UIViewController *)viewController{
    NSString *bundleName = [NSBundle bundleForClass:viewController.class].bundleURL.lastPathComponent;
    if ([bundleName isEqualToString:@"SwiftUI.framework"]) {
        return YES;
    }
    NSString *className = NSStringFromClass(viewController.class);
    return [className hasPrefix:@"SwiftUI."] || [className hasPrefix:@"_TtC7SwiftUI"] || [className hasPrefix:@"_TtGC7SwiftUI"] || [className containsString:@"UIHostingController"];
}
@end

#endif
