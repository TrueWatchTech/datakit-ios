//
//  FTAutoTrackProtocol.h
//  Pods
//
//  Created by hulilei on 2021/9/16.
//

#ifndef FTAutoTrackProtocol_h
#define FTAutoTrackProtocol_h

#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import <Foundation/Foundation.h>

@protocol FTMacRUMActionProperty <NSObject>
@optional
@property (nonatomic, copy, readonly) NSString *datakit_actionName;
//@property (nonatomic, weak, readonly) id datakit_controller;

@end
@protocol FTMacRumViewProperty <NSObject>
@property (nonatomic, strong) NSDate *datakit_viewLoadStartTime;
@property (nonatomic, strong) NSNumber *datakit_loadDuration;
@property (nonatomic, copy) NSString *datakit_viewUUID;
@property (nonatomic, copy, readonly) NSString *datakit_windowName;
@end

#endif


#endif /* FTAutoTrackProtocol_h */
