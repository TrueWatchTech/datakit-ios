//
//  FTRequestImageBody.h
//  FTMobileAgent
//
//  Created by hulilei on 2023/1/6.
//  Copyright © 2023 TRUEWATCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTRequestBody.h"

NS_ASSUME_NONNULL_BEGIN
@protocol FTMultipartFormBodyProtocol <NSObject>
- (NSString *)boundary;
- (void)addFormField:(NSString *)name value:(id)value;
- (void)addFormData:(NSString *)name filename:(NSString *)fileName data:(NSData *)data  mimeType:(NSString *)mimeType;
- (NSData *)build;
- (NSData *)newlineByte;
@end
@interface FTRequestMultipartFormBody : NSObject<FTMultipartFormBodyProtocol>
@property (nonatomic, copy) NSString *boundary;

@end

NS_ASSUME_NONNULL_END
