//
//  FTRecorder.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/8/1.
//  Copyright © 2023 TrueWatchTech. All rights reserved.
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
