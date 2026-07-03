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
//  FTWKWebViewRecorder.m
//  FTMobileSDK
//
//  Created by hulilei on 2025/4/18.
//
#if !TARGET_OS_TV
#import "FTWKWebViewRecorder.h"
#import "FTViewAttributes.h"
#import "FTSRWireframe.h"
#import "FTSRUtils.h"
#import "FTViewTreeRecordingContext.h"
#import "FTSystemColors.h"
#import <WebKit/WKWebView.h>
#import "WKWebView+FTAutoTrack.h"
@implementation FTWKWebViewRecorder
-(instancetype)init{
    self = [super init];
    if(self){
        _identifier = [[NSUUID UUID] UUIDString];
    }
    return self;
}

-(FTSRNodeSemantics *)recorder:(UIView *)view attributes:(FTViewAttributes *)attributes context:(FTViewTreeRecordingContext *)context{
    if(![view isKindOfClass:[WKWebView class]]){
        return nil;
    }
    WKWebView *webView = (WKWebView *)view;
    [context.webViewCache addObject:webView];
    CGFloat frameAdjustment = [self calculateFrameOffset:webView attributes:attributes];
    if (frameAdjustment > 0) {
        attributes.frame =  CGRectOffset(attributes.frame, 0, frameAdjustment);
    }
    FTWKWebViewBuilder *builder = [[FTWKWebViewBuilder alloc]init];
    builder.slotID = webView.hash;
    builder.attributes = attributes;
    builder.linkRUMKeysInfo = webView.ft_linkRumKeysInfo;
    FTSpecificElement *element = [[FTSpecificElement alloc]initWithSubtreeStrategy:NodeSubtreeStrategyIgnore];
    element.nodes = @[builder];
    return element;
}

- (float)calculateFrameOffset:(WKWebView *)webView attributes:(FTViewAttributes *)attributes{
    if (@available(iOS 11.0, *)) {
        if (webView.scrollView.contentInsetAdjustmentBehavior != UIScrollViewContentInsetAdjustmentNever) {
            CGFloat safeAreaTop = webView.safeAreaInsets.top;
            if (CGRectGetMinX(attributes.frame) < safeAreaTop) {
                CGFloat scale = webView.window != nil ? webView.window.screen.scale : 1;
                return safeAreaTop / scale;
            }
        }
    }
    return -1;
}
@end

@implementation FTWKWebViewBuilder
-(CGRect)wireframeRect{
    return self.attributes.frame;
}
- (NSArray<FTSRWireframe *> *)buildWireframesWithBuilder:(FTSessionReplayWireframesBuilder *)builder{
    FTSRWebViewWireframe *wireframe = (FTSRWebViewWireframe *)[builder visibleWebViewWireframeWithID:self.slotID attributes:self.attributes linkRUMKeysInfo:self.linkRUMKeysInfo];
    return @[wireframe];
}

@end
#endif

#endif
