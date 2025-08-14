//
//  FTTLVReader.h
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/24.
//  Copyright © 2024 TRUEWATCH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class FTTLV;
@interface FTTLVReader : NSObject
-(instancetype)initWithStream:(NSInputStream *)stream;
-(instancetype)initWithStream:(NSInputStream *)stream maxDataLength:(NSUInteger)length;

- (NSArray<FTTLV*> *)all;
@end

NS_ASSUME_NONNULL_END
