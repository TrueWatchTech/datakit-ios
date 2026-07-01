//
//  FTTouchSnapshot.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/9/5.
//  Copyright © 2024 TrueWatchTech. All rights reserved.
//

#import "FTTouchSnapshot.h"
@implementation FTTouchCircle

@end
@implementation FTTouchSnapshot
- (instancetype)initWithTouches:(NSArray<FTTouchCircle*> *)touches{
    self = [super init];
    if(self){
        _touches = touches;
        _timestamp = touches.firstObject.timestamp;
    }
    return self;
}
@end
