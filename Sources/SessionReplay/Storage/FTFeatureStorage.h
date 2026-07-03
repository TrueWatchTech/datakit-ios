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
//  FTDataStorage.h
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/21.
//

#import <Foundation/Foundation.h>
@class FTPerformancePreset,FTDirectory,FTFeatureDirectories;
NS_ASSUME_NONNULL_BEGIN
@protocol FTWriter,FTReader,FTCacheWriter;
typedef NS_ENUM(NSInteger, FTTrackingConsent) {
    FTTrackingConsentGranted,
    FTTrackingConsentNotGranted,
    FTTrackingConsentPending,
    FTTrackingConsentErrorSampled,
};
@interface FTFeatureStorage : NSObject
-(instancetype)initWithFeatureName:(NSString *)featureName
                             queue:(dispatch_queue_t)queue
                       directories:(FTFeatureDirectories *)directories
                       performance:(FTPerformancePreset *)performance;

- (void)updateTrackingConsent:(FTTrackingConsent)trackingConsent;
- (id<FTWriter>)writerForTrackingConsent:(FTTrackingConsent)trackingConsent NS_SWIFT_NAME(writer(for:));
- (id<FTWriter>)webViewWriterForTrackingConsent:(FTTrackingConsent)trackingConsent NS_SWIFT_NAME(webViewWriter(for:));
- (id<FTReader>)reader;
- (nullable id<FTCacheWriter>)cacheWriter;
- (void)migrateUnauthorizedDataToConsent:(FTTrackingConsent)trackingConsent;
- (void)clearUnauthorizedData;
- (void)clearAllData;
- (void)setIgnoreFilesAgeWhenReading:(BOOL)ignore;
@end

NS_ASSUME_NONNULL_END

#endif
