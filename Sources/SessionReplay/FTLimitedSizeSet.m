//
//  FTLimitedSizeSet.m
//  SessionReplay
//
//  Created by hulilei on 2025/9/28.
//
//  Copyright 2025 Shanghai Guance Information Technology Co., Ltd.
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

#import "FTLimitedSizeSet.h"

@interface FTLimitedSizeSet()
@property (nonatomic, strong) NSMutableSet *storageSet;
@property (nonatomic, strong) NSMutableArray *orderArray;
@property (nonatomic, assign) NSUInteger maxCount;

@end

@implementation FTLimitedSizeSet

- (instancetype)initWithMaxCount:(NSUInteger)maxCount {
    self = [super init];
    if (self) {
        _maxCount = maxCount;
        _storageSet = [NSMutableSet set];
        _orderArray = [NSMutableArray array];
    }
    return self;
}

- (void)addObject:(id<NSCopying>)object {
    if ([self.storageSet containsObject:object]) {
        [self.storageSet removeObject:object];
        [self.orderArray removeObject:object];
    }
    
    if (self.storageSet.count >= self.maxCount) {
        id oldestObject = self.orderArray.firstObject;
        [self.storageSet removeObject:oldestObject];
        [self.orderArray removeObjectAtIndex:0];
    }
    
   
    [self.storageSet addObject:object];
    [self.orderArray addObject:object];
}

- (BOOL)containsObject:(id)object {
    return [self.storageSet containsObject:object];
}

- (void)removeObject:(id)object {
    [self.storageSet removeObject:object];
    [self.orderArray removeObject:object];
}

- (NSUInteger)count {
    return self.storageSet.count;
}

- (void)removeAllObjects {
    [self.storageSet removeAllObjects];
    [self.orderArray removeAllObjects];
}

@end

#endif
