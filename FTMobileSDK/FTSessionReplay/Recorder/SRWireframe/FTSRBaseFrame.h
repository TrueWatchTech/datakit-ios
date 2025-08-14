//
//  FTSRBaseFrame.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/8/7.
//  Copyright © 2023 TRUEWATCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTJSONKeyMapper.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FTAbstractJSONModelProtocol <NSObject>
- (NSDictionary *)toDictionary;
- (NSString*)toJSONString;
- (NSData*)toJSONData;
@end
/// Only supports basic types, NSArray, NSString, NSNumber
@interface FTSRBaseFrame : NSObject<NSCoding,NSSecureCoding,FTAbstractJSONModelProtocol>
+ (nullable FTJSONKeyMapper *)keyMapper;
@end

@interface FTSRBaseFrameProperty : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) Class type;
@property (copy, nonatomic) NSString *protocol;
@end
NS_ASSUME_NONNULL_END
