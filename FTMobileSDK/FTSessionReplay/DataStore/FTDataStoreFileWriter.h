//
//  FTDataStoreFileWriter.h
//  FTMobileSDK
//
//  Created by hulilei on 2024/7/2.
//  Copyright © 2024 TrueWatchTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTDataStore.h"
NS_ASSUME_NONNULL_BEGIN
@class FTFile;
@interface FTDataStoreFileWriter : NSObject
-(instancetype)initWithFile:(FTFile *)file;
- (void)write:(NSData *)data version:(FTDataStoreKeyVersion)version;
@end

NS_ASSUME_NONNULL_END
