//
//  FTVisitorIDManager+Private.h
//  FTMobileSDK
//
//  Copyright 2026 TRUEWATCH TECHNOLOGY INC PTE. LTD.
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

#import "FTVisitorIDManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FTVisitorIDStorage <NSObject>
- (nullable NSDictionary<NSString *, id> *)readRecord;
- (BOOL)writeRecord:(NSDictionary<NSString *, id> *)record;
- (void)removeRecord;
@end

@protocol FTVisitorIDClock <NSObject>
- (NSDate *)now;
@end

@interface FTVisitorIDManager ()
- (instancetype)initWithStorage:(id<FTVisitorIDStorage>)storage
                           clock:(id<FTVisitorIDClock>)clock NS_DESIGNATED_INITIALIZER;
/// Temporarily associates the request snapshot with an automatically collected Resource.
/// The RUM start entry point consumes this value synchronously before queueing its model.
- (void)bindResourceVisitorID:(nullable NSString *)visitorID forKey:(NSString *)key;
- (nullable NSString *)consumeResourceVisitorIDForKey:(NSString *)key;
- (instancetype)init NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
