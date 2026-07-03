//  Copyright 2024 Shanghai Guance Information Technology Co., Ltd.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <TargetConditionals.h>
#if TARGET_OS_IOS
//
//  FTDataStore.h
//  FTMobileSDK
//
//  Created by hulilei on 2024/7/1.
//

#ifndef FTDataStore_h
#define FTDataStore_h
typedef uint16_t FTDataStoreKeyVersion;

// Saved data, when data structure changes, update this constant to distinguish between old and new data, can be compatible with old data or directly delete
static FTDataStoreKeyVersion const DataStoreDefaultKeyVersion = 0;

typedef NS_ENUM(uint16_t,DataStoreBlockType) {
    DataStoreBlockTypeVersion = 0x00,
    DataStoreBlockTypeData = 0X01,
};

typedef void (^DataStoreValueResult)(NSError *error,NSData *data,FTDataStoreKeyVersion version);
@protocol FTDataStore <NSObject>
- (void)setValue:(NSData*)value forKey:(NSString *)key version:(FTDataStoreKeyVersion)version;
- (void)removeValueForKey:(NSString *)key;
- (void)valueForKey:(NSString *)key callback:(DataStoreValueResult)callback;
@end

#endif /* FTDataStore_h */

#endif
