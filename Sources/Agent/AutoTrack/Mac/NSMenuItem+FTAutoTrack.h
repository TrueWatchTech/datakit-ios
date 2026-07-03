//
//  NSMenuItem+FTAutoTrack.h
//  FTSDK
//
//  Created by hulilei on 2021/9/28.
//

#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#import "FTAutoTrackProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSMenuItem (FTAutoTrack)<FTMacRUMActionProperty>


@end

NS_ASSUME_NONNULL_END
#endif
