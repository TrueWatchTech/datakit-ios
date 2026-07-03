//
//  FTWindowObserver.m
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

#import "FTWindowObserver.h"

@implementation FTWindowObserver
- (nullable UIApplication *)_findApp{
    if ([UIApplication respondsToSelector:@selector(sharedApplication)]) {
        return [UIApplication performSelector:@selector(sharedApplication)];
    }
    return nil;
}
- (UIWindowScene *)_activeWindowScene  API_AVAILABLE(ios(13.0)){
    UIApplication *app = [self _findApp];
    if (app == nil) {
        return nil;
    }

    if (@available(iOS 13.0, *)) {
        UIScene *foregroundActiveScene = nil;
        UIScene *foregroundInactiveScene = nil;

        for (UIScene *scene in app.connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) {
                continue;
            }

            if (scene.activationState == UISceneActivationStateForegroundActive) {
                foregroundActiveScene = scene;
                break;
            }

            if (!foregroundInactiveScene &&
                scene.activationState == UISceneActivationStateForegroundInactive) {
                foregroundInactiveScene = scene;
            }
        }

        UIScene *sceneToUse = foregroundActiveScene ?: foregroundInactiveScene;
        return (UIWindowScene *)sceneToUse;
    }

    return nil;
}
-(UIWindow *)keyWindow{
    // Prevent compilation failure in WidgetExtension environment
    UIApplication *app = [self _findApp];
    if(app == nil){
        return nil;
    }
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = [self _activeWindowScene];
        if (!windowScene) return nil;
        
        if (@available(iOS 15.0, *)) {
            return windowScene.keyWindow;
        }
        
        for (UIWindow *window in windowScene.windows) {
            if (window.isKeyWindow) {
                return window;
            }
        }
        return nil;
    }
    if ([app.delegate respondsToSelector:@selector(window)]){
        return [app.delegate window];
    }else{
        return [app keyWindow];
    }
}
- (NSArray<UIWindow *>*)windows{
    UIApplication *app = [self _findApp];
    if(app == nil){
        return nil;
    }
    if (@available(iOS 13.0, *)) {
        UIWindowScene *windowScene = [self _activeWindowScene];
        return windowScene.windows;
    }
    return [app windows];
}
@end

#endif
