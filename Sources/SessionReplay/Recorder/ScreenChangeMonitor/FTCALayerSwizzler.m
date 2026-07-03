//
//  FTCALayerSwizzler.m
//  SessionReplay
//
//  Created by hulilei on 2026/3/4.
//
//  Copyright 2026 Shanghai Guance Information Technology Co., Ltd.
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

#import "FTCALayerSwizzler.h"
#import "FTSessionReplayCoreImports.h"

static __weak id<FTCALayerObserver> ft_currentLayerObserver = nil;
static void *const kFTSwizzleDisplay = (void *)&kFTSwizzleDisplay;
static void *const kFTSwizzleDrawInContext = (void *)&kFTSwizzleDrawInContext;
static void *const kFTSwizzleLayoutSublayers = (void *)&kFTSwizzleLayoutSublayers;

@implementation FTCALayerSwizzler

- (instancetype)initWithObserver:(id<FTCALayerObserver>)observer {
    self = [super init];
    if (self) {
        ft_currentLayerObserver = observer;
    }
    return self;
}

- (void)swizzleIfNeeded {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleDisplay];
        [self swizzleDraw];
        [self swizzleLayoutSublayers];
    });
}

#pragma mark - Display

- (void)swizzleDisplay {
    FTSwizzlerInstanceMethod([CALayer class], @selector(display), FTSWReturnType(void), FTSWArguments(), FTSWReplacement({
        FTSWCallOriginal();
        __strong id<FTCALayerObserver> observer = ft_currentLayerObserver;
        if (observer) {
            [observer layerDidDisplay:self];
        }
    }), FTSwizzlerModeOncePerClass, kFTSwizzleDisplay);
}

#pragma mark - Draw

- (void)swizzleDraw {
    FTSwizzlerInstanceMethod([CALayer class], @selector(drawInContext:), FTSWReturnType(void), FTSWArguments(CGContextRef context), FTSWReplacement({
        FTSWCallOriginal(context);
        __strong id<FTCALayerObserver> observer = ft_currentLayerObserver;
        if (observer) {
            [observer layerDidDraw:self inContext:context];
        }
    }), FTSwizzlerModeOncePerClass, kFTSwizzleDrawInContext);
}

#pragma mark - Layout

- (void)swizzleLayoutSublayers {
    FTSwizzlerInstanceMethod([CALayer class], @selector(layoutSublayers), FTSWReturnType(void), FTSWArguments(), FTSWReplacement({
        FTSWCallOriginal();
        __strong id<FTCALayerObserver> observer = ft_currentLayerObserver;
        if (observer) {
            [observer layerDidLayoutSublayers:self];
        }
    }), FTSwizzlerModeOncePerClass, kFTSwizzleLayoutSublayers);
}

@end

#endif
