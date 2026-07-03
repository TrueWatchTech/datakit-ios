//
//  FTUIActivityIndicatorRecorder.m
//  SessionReplay
//
//  Created by hulilei on 2024/7/12.
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

#import "FTUIActivityIndicatorRecorder.h"
#import "FTSRWireframe.h"
#import "FTViewAttributes.h"
#import "FTSRUtils.h"
#import "FTSystemColors.h"
#import "FTViewTreeRecordingContext.h"
#import "FTSRUtils.h"
#import "FTViewTreeRecorder.h"
#import "FTUIImageViewRecorder.h"
@interface FTUIActivityIndicatorRecorder()
@property (nonatomic, strong) FTViewTreeRecorder *subtreeRecorder;
@end
@implementation FTUIActivityIndicatorRecorder
-(instancetype)init{
    self = [super init];
    if(self){
        _identifier = [[NSUUID UUID] UUIDString];
    }
    return self;
}
-(FTSRNodeSemantics *)recorder:(UIView *)view attributes:(FTViewAttributes *)attributes context:(FTViewTreeRecordingContext *)context{
    if(![view isKindOfClass:[UIActivityIndicatorView class]]){
        return nil;
    }
    if(!attributes.isVisible){
        return [FTInvisibleElement constant];
    }
    UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView*)view;
    if(activityIndicator.isAnimating || !activityIndicator.hidesWhenStopped){
        FTUIActivityIndicatorBuilder *builder = [[FTUIActivityIndicatorBuilder alloc]init];
        builder.attributes = attributes;
        builder.wireframeID = [context.viewIDGenerator SRViewID:activityIndicator nodeRecorder:self];
        builder.backgroundColor = [FTSRColorSnapshot snapshotWithColor:activityIndicator.backgroundColor traitCollection:activityIndicator.traitCollection];
        NSMutableArray *records = [NSMutableArray arrayWithArray:@[builder]];
        NSMutableArray *resources = [NSMutableArray array];
        [self recordSubtree:activityIndicator records:records resources:resources context:context];
        FTSpecificElement *element = [[FTSpecificElement alloc]initWithSubtreeStrategy:NodeSubtreeStrategyIgnore];
        element.nodes = records;
        return element;
    }else{
        return [FTInvisibleElement constant];
    }
}
- (void)recordSubtree:(UIActivityIndicatorView *)activityIndicator records:(NSMutableArray *)records resources:(NSMutableArray *)resources context:(FTViewTreeRecordingContext *)context{
    if(!_subtreeRecorder){
        FTViewTreeRecorder *viewTreeRecorder = [[FTViewTreeRecorder alloc]init];
        FTUIImageViewRecorder *imageViewRecorder = [[FTUIImageViewRecorder alloc]initWithIdentifier:self.identifier tintColorProvider:nil shouldRecordImagePredicateOverride: ^BOOL(UIImageView * _Nonnull imageView) {
            return imageView.image != nil;
        }];
        viewTreeRecorder.nodeRecorders = @[imageViewRecorder];
        self.subtreeRecorder = viewTreeRecorder;
    }
    [self.subtreeRecorder record:records view:activityIndicator context:context];
}
@end

@implementation FTUIActivityIndicatorBuilder

-(NSArray<FTSRWireframe *> *)buildWireframesWithBuilder:(FTSessionReplayWireframesBuilder *)builder;{
    FTSRShapeWireframe *wireframe = [[FTSRShapeWireframe alloc]initWithIdentifier:self.wireframeID frame:self.wireframeRect clip:self.attributes.clip backgroundColor:self.backgroundColor.hexString cornerRadius:@(self.attributes.layerCornerRadius) opacity:@(self.attributes.alpha)];
    return @[wireframe];
}
-(CGRect)wireframeRect{
    return self.attributes.frame;
}
@end


#endif
