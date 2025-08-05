//
//  FTRUMView.m
//  FTMobileSDK
//
//  Created by hulilei on 2025/7/23.
//  Copyright © 2025 TRUEWATCH. All rights reserved.
//

#import "FTRUMView.h"

@implementation FTRUMView
-(instancetype)initWithViewName:(NSString *)viewName{
    return [self initWithViewName:viewName property:nil];
}
- (instancetype)initWithViewName:(NSString *)viewName property:(NSDictionary *)property{
    self = [super init];
    if (self) {
        _viewName = viewName;
        _property = property;
    }
    return self;
}
@end
