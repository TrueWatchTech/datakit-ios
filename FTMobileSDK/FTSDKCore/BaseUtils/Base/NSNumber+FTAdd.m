//
//  NSNumber+FTAdd.m
//  FTMobileSDK
//
//  Created by hulilei on 2023/7/25.
//  Copyright © 2023 TRUEWATCH. All rights reserved.
//

#import "NSNumber+FTAdd.h"

@implementation NSNumber (FTAdd)

- (BOOL)ft_isBool {
    return [self isKindOfClass:NSClassFromString(@"__NSCFBoolean")];
}

- (id)ft_toFieldFormat{
    if ([self ft_isBool]) {
        return [self boolValue] ? @"true": @"false";
    }if (strcmp([self objCType], @encode(float)) == 0){
        return [NSString stringWithFormat:@"%.2f",self.floatValue];
    }else if(strcmp([self objCType], @encode(double)) == 0){
        return [NSString stringWithFormat:@"%.2f",self.doubleValue];
    }else{
        return [NSString stringWithFormat:@"%@i", self];
    }
    return self;
}
- (id)ft_toFieldIntegerCompatibleFormat{
    if ([self ft_isBool]) {
        return [self boolValue] ? @"true": @"false";
    }if (strcmp([self objCType], @encode(float)) == 0){
        return [NSString stringWithFormat:@"%.2f",self.floatValue];
    }else if(strcmp([self objCType], @encode(double)) == 0){
        return [NSString stringWithFormat:@"%.2f",self.doubleValue];
    }
    return self;
}
- (id)ft_toTagFormat{
    if ([self ft_isBool]) {
        return [self boolValue] ? @"true": @"false";
    }else if (strcmp([self objCType], @encode(float)) == 0){
        return [NSString stringWithFormat:@"%.2f",self.floatValue];
    }else if(strcmp([self objCType], @encode(double)) == 0){
        return [NSString stringWithFormat:@"%.2f",self.doubleValue];
    }
    return self;
}
- (id)ft_toUserFieldFormat{
   if (strcmp([self objCType], @encode(float)) == 0||strcmp([self objCType], @encode(double)) == 0){
       return self.stringValue;
    }
    return self;
}
@end
