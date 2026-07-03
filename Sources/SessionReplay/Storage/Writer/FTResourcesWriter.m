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
//  FTResourcesWriter.m
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/25.
//

#import "FTResourcesWriter.h"
#import "FTSRRecord.h"
#import "FTFileWriter.h"
#import <pthread.h>
#import "FTFeatureDataStore.h"
#import "FTFeatureScope.h"
#import "FTSessionReplayCoreImports.h"

NSString *const FT_StoreCreationKey = @"ft-store-creation";
NSString *const FT_KnownResourcesKey = @"ft-known-resources";
@interface FTResourcesWriter(){
    pthread_rwlock_t _lock;
}
@property (nonatomic, strong) FTFeatureScope *featureScope;
@property (nonatomic, strong) NSMutableSet *knownIdentifiers;
@property (nonatomic, strong, nullable) id<FTDataStore> dataStore;
@property (nonatomic, assign) NSTimeInterval dataStoreResetTime;
@end
@implementation FTResourcesWriter

- (instancetype)initWithFeatureScope:(FTFeatureScope *)featureScope dataStore:(nullable id<FTDataStore>)dataStore{
    self = [super init];
    if(self){
        _featureScope = featureScope;
        _knownIdentifiers = [[NSMutableSet alloc]init];
        _dataStore = dataStore;
        _dataStoreResetTime = 30*24*60*60;//30 day
        pthread_rwlock_init(&_lock, NULL);
        [self readKnownIdentifiers];
    }
    return self;
}
-(NSMutableSet *)knownIdentifiers{
    NSMutableSet *known;
    pthread_rwlock_rdlock(&_lock);
    known = [_knownIdentifiers mutableCopy];
    pthread_rwlock_unlock(&_lock);
    return known;
}
-(void)mutate:(void (^)(void))block{
    pthread_rwlock_wrlock(&_lock);
    block();
    pthread_rwlock_unlock(&_lock);
}
- (void)readKnownIdentifiers{
    if (!self.dataStore) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.dataStore valueForKey:FT_StoreCreationKey callback:^(NSError *error, NSData *data, FTDataStoreKeyVersion version) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if(!error){
            if(version == DataStoreDefaultKeyVersion && ([[NSDate date] timeIntervalSince1970] - [strongSelf transDataAsTimeInterval:data] < strongSelf.dataStoreResetTime)){
                    [strongSelf.dataStore valueForKey:FT_KnownResourcesKey callback:^(NSError *error, NSData *data, FTDataStoreKeyVersion version) {
                        if(!error){
                            if(version != DataStoreDefaultKeyVersion){
                                FTInnerLogError(@"[Session Replay] Resource Writer Read KnownIdentifiers Error");
                            }else if(data!=nil){
                                NSError *error;
                                NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                if(array){
                                    [strongSelf mutate:^{
                                        [strongSelf->_knownIdentifiers addObjectsFromArray:array];
                                    }];
                                   
                                }
                            }
                        }else{
                            FTInnerLogError(@"[Session Replay] Resource Writer Read KnownIdentifiers Error: %@",error.localizedDescription);
                        }
                    }];
            }else{
                [weakSelf.dataStore setValue:[weakSelf transTimeIntervalAsData:[[NSDate date] timeIntervalSince1970]] forKey:FT_StoreCreationKey version:DataStoreDefaultKeyVersion];
                [weakSelf.dataStore removeValueForKey:FT_KnownResourcesKey];
            }
        }else{
            FTInnerLogError(@"[Session Replay] Resource Writer Error: %@",error.localizedDescription);
        }
    }];
}
- (void)write:(NSArray<FTEnrichedResource*>*)resources{
    __weak typeof(self) weakSelf = self;
    [self.featureScope eventWriteContext:^(FTFeatureContext *context, id<FTWriter> writer) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        if (context.trackingConsent == FTTrackingConsentNotGranted) {
            return;
        }
        NSMutableSet *unknownResources = [NSMutableSet new];
        NSSet *currentKnownIdentifiers = strongSelf.knownIdentifiers;
        [resources enumerateObjectsUsingBlock:^(FTEnrichedResource * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(![currentKnownIdentifiers containsObject:obj.identifier]){
                [writer write:[obj toJSONData]];
                [unknownResources addObject:obj.identifier];
            }
        }];
        [strongSelf storeUnknownResources:unknownResources];
    }];
}
- (void)storeUnknownResources:(NSSet *)unknownResources{
    if(unknownResources.count>0){
        [self mutate:^{
            [self->_knownIdentifiers unionSet:unknownResources];
        }];
        NSSet *updatedKnownIdentifiers = self.knownIdentifiers;
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:[updatedKnownIdentifiers allObjects] options:0 error:&error];
        if(data){
            [self.dataStore setValue:data forKey:FT_KnownResourcesKey version:DataStoreDefaultKeyVersion];
        }
    }
}
- (NSTimeInterval)transDataAsTimeInterval:(NSData *)data{
    NSTimeInterval timeInterval = 0;
    if(data.length>=sizeof(NSTimeInterval)){
        [data getBytes:&timeInterval length:data.length];
    }
    return timeInterval;
}
- (NSData *)transTimeIntervalAsData:(NSTimeInterval)timeInterval{
    return [NSData dataWithBytes:&timeInterval length:sizeof(timeInterval)];
}
@end

#endif
