//
//  FTAutoTrack.h
//  GuanceSDK
//
//  Created by hulilei on 2021/9/9.
//

#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import <Foundation/Foundation.h>
#import "FTRumDatasProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface FTAutoTrack : NSObject
@property (nonatomic,weak) id<FTRumDatasProtocol> addRumDatasDelegate;
/// Singleton
+ (instancetype)sharedInstance;
- (void)startHookView:(BOOL)enableView action:(BOOL)enableAction;
- (void)trackActionWithName:(nullable NSString *)actionName;
@end

NS_ASSUME_NONNULL_END
#endif
