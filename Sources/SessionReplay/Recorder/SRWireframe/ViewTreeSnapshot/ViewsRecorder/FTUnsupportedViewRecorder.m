//
//  FTUnsupportedViewRecorder.m
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

#import "FTUnsupportedViewRecorder.h"
#import "FTSRWireframe.h"
#import "FTViewAttributes.h"
#import "FTSRUtils.h"
#import "FTViewTreeRecordingContext.h"
@interface FTUnsupportedViewRecorder()
@property (nonatomic, assign) BOOL swiftUIEnabled;
@end
@implementation FTUnsupportedViewRecorder
-(instancetype)init{
    return [self initWithSwiftUIEnabled:NO];
}
-(instancetype)initWithSwiftUIEnabled:(BOOL)swiftUIEnabled{
    self = [super init];
    if(self){
        _identifier = [[NSUUID UUID] UUIDString];
        _swiftUIEnabled = swiftUIEnabled;
    }
    return self;
}
- (FTSRNodeSemantics *)recorder:(nonnull UIView *)view attributes:(nonnull FTViewAttributes *)attributes context:(FTViewTreeRecordingContext *)context {
    // Whether it's a controller that shouldn't be collected
    BOOL isUnsupportedRootView = [context.viewControllerContext isRootView:ViewControllerTypeSafari] || [context.viewControllerContext isRootView:ViewControllerTypeActivity] || (!self.swiftUIEnabled && [context.viewControllerContext isRootView:ViewControllerTypeSwiftUI]);
    if(isUnsupportedRootView){
        
        // Whether View is invisible
        if (!attributes.isVisible){
            FTInvisibleElement *element = [[FTInvisibleElement alloc]initWithSubtreeStrategy:NodeSubtreeStrategyIgnore];
            return element;
        }
        FTUnsupportedViewBuilder *builder = [[FTUnsupportedViewBuilder alloc]init];
        builder.wireframeRect = view.frame;
        builder.wireframeID = [context.viewIDGenerator SRViewID:view nodeRecorder:self];
        builder.unsupportedClassName = context.viewControllerContext.name?:NSStringFromClass(view.class);
        builder.attributes = attributes;
        FTSpecificElement *element = [[FTSpecificElement alloc]initWithSubtreeStrategy:NodeSubtreeStrategyIgnore];
        element.nodes = @[builder];
        return element;
    }
    return nil;
}
@end

@implementation FTUnsupportedViewBuilder

- (NSArray<FTSRWireframe *> *)buildWireframesWithBuilder:(FTSessionReplayWireframesBuilder *)builder{
    FTSRPlaceholderWireframe *wireframe = [[FTSRPlaceholderWireframe alloc]initWithIdentifier:self.wireframeID frame:self.attributes.frame label:self.unsupportedClassName];
    wireframe.clip = [[FTSRContentClip alloc] initWithFrame:self.attributes.frame clip:self.attributes.clip];
    return @[wireframe];
}

@end

#endif
