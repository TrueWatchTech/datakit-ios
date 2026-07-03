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
//  FTRecorder.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/8/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FTWindowObserver,FTSRContext,FTTouchSnapshot,FTSnapshotProcessor;
@protocol FTWriter,FTSRWireframesRecorder;
@interface FTRecorder : NSObject
@property (nonatomic, strong) FTSnapshotProcessor *snapshotProcessor;
-(instancetype)initWithWindowObserver:(FTWindowObserver *)observer snapshotProcessor:(FTSnapshotProcessor *)snapshotProcessor 
              additionalNodeRecorders:(NSArray<id <FTSRWireframesRecorder>>*)additionalNodeRecorders
                        enableSwiftUI:(BOOL)enableSwiftUI;
;
-(void)taskSnapShot:(FTSRContext *)context touchSnapshot:(nullable FTTouchSnapshot *)touchSnapshot;
@end

NS_ASSUME_NONNULL_END

#endif
