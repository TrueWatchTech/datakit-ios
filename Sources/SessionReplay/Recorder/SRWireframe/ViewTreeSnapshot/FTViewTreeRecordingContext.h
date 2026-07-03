//
//  FTViewTreeRecordingContext.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WKWebView.h>
NS_ASSUME_NONNULL_BEGIN
@class FTSRContext,FTSRViewID,FTViewControllerContext;
@interface FTViewTreeRecordingContext : NSObject
@property (nonatomic, strong) FTSRContext *recorder;
@property (nonatomic, strong) FTSRViewID *viewIDGenerator;
@property (nonatomic, strong) id<UICoordinateSpace> coordinateSpace;
@property (nonatomic, strong) FTViewControllerContext *viewControllerContext;
@property (nonatomic, strong, nullable) NSHashTable<WKWebView*> *webViewCache;

@property (nonatomic, assign) CGRect clip;
@end

typedef NS_ENUM(NSUInteger,ViewControllerType){
    ViewControllerTypeAlert,
    ViewControllerTypeSafari,
    ViewControllerTypeActivity,
    ViewControllerTypeSwiftUI,
    ViewControllerTypeOther
};
@interface FTViewControllerContext : NSObject
@property (nonatomic, assign) BOOL isRootView;
@property (nonatomic, assign) ViewControllerType parentType;
- (BOOL)isRootView:(ViewControllerType)type;
- (nullable NSString *)name;
- (void)setParentTypeWithViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END

#endif
