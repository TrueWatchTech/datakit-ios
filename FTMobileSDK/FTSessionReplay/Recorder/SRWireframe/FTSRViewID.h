//
//  FTSRViewID.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/8/3.
//  Copyright © 2023 TRUEWATCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol FTSRWireframesRecorder;
@interface FTSRViewID : NSObject
- (int)SRViewID:(UIView *)view nodeRecorder:(id<FTSRWireframesRecorder>)nodeRecorder;
- (NSArray*)SRViewIDs:(UIView *)view size:(int)size nodeRecorder:(id<FTSRWireframesRecorder>)nodeRecorder;
@end

NS_ASSUME_NONNULL_END
