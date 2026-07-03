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
//  FTRecorder.m
//  FTMobileSDK
//
//  Created by hulilei on 2023/8/1.
//

#import "FTRecorder.h"
#import "FTWindowObserver.h"
#import "FTViewAttributes.h"
#import "FTTouchSnapshot.h"
#import "FTViewAttributes.h"
#import "FTSRWireframe.h"
#import "FTSRNodeWireframesBuilder.h"
#import "FTSessionReplayCoreImports.h"
#import "FTSRRecord.h"
#import "FTNodesFlattener.h"
#import "FTSnapshotProcessor.h"
#import "FTViewTreeSnapshotBuilder.h"
#import "FTResourcesWriter.h"
@interface FTRecorder()
@property (nonatomic, strong) FTWindowObserver *windowObserver;
@property (nonatomic, strong) FTViewTreeSnapshotBuilder *viewSnapShotBuilder;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@end
@implementation FTRecorder
-(instancetype)initWithWindowObserver:(FTWindowObserver *)observer
                    snapshotProcessor:(FTSnapshotProcessor *)snapshotProcessor
              additionalNodeRecorders:(NSArray<id <FTSRWireframesRecorder>>*)additionalNodeRecorders
                        enableSwiftUI:(BOOL)enableSwiftUI;{
    self = [super init];
    if(self){
        _windowObserver = observer;
        _viewSnapShotBuilder = [[FTViewTreeSnapshotBuilder alloc]initWithAdditionalNodeRecorders:additionalNodeRecorders enableSwiftUI:enableSwiftUI];
        _snapshotProcessor = snapshotProcessor;
    }
    return self;
}
-(void)taskSnapShot:(FTSRContext *)context touchSnapshot:(FTTouchSnapshot *)touchSnapshot{
    
    NSArray <UIWindow *> *rootViews = self.windowObserver.windows ;
    UIWindow *keyWindow = self.windowObserver.keyWindow ;
    if(rootViews == nil || rootViews.count == 0 || keyWindow == nil){
        return;
    }
    // 1.Collect view snap shot
    FTViewTreeSnapshot *viewTreeSnapshot = [self.viewSnapShotBuilder takeSnapshot:rootViews referenceView:keyWindow context:context];
    [self.snapshotProcessor process:viewTreeSnapshot touchSnapshot:touchSnapshot];
}
@end
 

#endif
