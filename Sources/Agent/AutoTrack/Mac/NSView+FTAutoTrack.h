//
//  NSView+FTAutoTrack.h
//  Pods
//
//  Created by hulilei on 2021/9/15.
//

#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#import "FTAutoTrackProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSView (FTAutoTrack)<FTMacRUMActionProperty>

@end

NS_ASSUME_NONNULL_END
#endif
