//
//  NSTabView+FTAutoTrack.h
//  GuanceSDK
//
//  Created by hulilei on 2021/9/26.
//

#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTabView (FTAutoTrack)
-(void)datakit_setDelegate:(id<NSTabViewDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
#endif
