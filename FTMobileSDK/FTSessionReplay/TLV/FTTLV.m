//
//  FTTLV.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/24.
//  Copyright © 2024 TRUEWATCH. All rights reserved.
//

#import "FTTLV.h"
NSUInteger const FT_MAX_DATA_LENGTH = 10*1024*1024;

@implementation FTTLV
-(instancetype)initWithType:(uint16_t)type value:(NSData *)value{
    self = [super init];
    if(self){
        _type = type;
        _value = value;
    }
    return self;
}
///         int16_t       int32_t
///     +-  2 bytes -+-   4 bytes   -+- n bytes -|
///     | block type | data size (n) |    data   |
///     +------------+---------------+-----------+
- (NSData *)serialize{
    return [self serialize:FT_MAX_DATA_LENGTH];
}
-(NSData *)serialize:(UInt64)maxLength{
    if(_value.length<=maxLength){
        NSMutableData *data = [NSMutableData data];
        NSData *typeData = [NSData dataWithBytes:&_type length:sizeof(_type)];
        int32_t length = (int32_t)_value.length;
        NSData *lengthData = [NSData dataWithBytes:&length length:sizeof(length)];
        
        [data appendData:typeData];
        [data appendData:lengthData];
        [data appendData:_value];
        return data;
    }
    return nil;
}
@end
