//
//  NSWindow+FTAutoTrack.h
//  GuanceSDK
//
//  Created by hulilei on 2021/9/9.
//

#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#import "FTAutoTrackProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSWindow (FTAutoTrack)<FTMacRumViewProperty>

-(instancetype)datakit_init;
-(instancetype)datakit_initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag;
- (instancetype)datakit_initWithCoder:(NSCoder *)coder;
-(void)datakit_becomeKeyWindow;
-(void)datakit_resignKeyWindow;
@end

NS_ASSUME_NONNULL_END
#endif
