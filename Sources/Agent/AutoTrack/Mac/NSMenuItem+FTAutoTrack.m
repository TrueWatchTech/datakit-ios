//
//  NSMenuItem+FTAutoTrack.m
//  GuanceSDK
//
//  Created by hulilei on 2021/9/28.
//

#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import "NSMenuItem+FTAutoTrack.h"

@implementation NSMenuItem (FTAutoTrack)
-(NSString *)datakit_actionName{
    return [NSString stringWithFormat:@"[NSMenuItem]%@",self.title];
}
@end
#endif
