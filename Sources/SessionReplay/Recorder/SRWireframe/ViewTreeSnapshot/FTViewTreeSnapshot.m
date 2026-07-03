//
//  FTViewTreeSnapshot.m
//  SessionReplay
//
//  Created by hulilei on 2024/6/13.
//
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

#import "FTViewTreeSnapshot.h"

@implementation FTViewTreeSnapshot

@end
@implementation FTSRNodeSemantics
-(instancetype)initWithSubtreeStrategy:(NodeSubtreeStrategy)subtreeStrategy{
    self = [super init];
    if(self){
        _subtreeStrategy = subtreeStrategy;
    }
    return self;
}

@end
@implementation FTUnknownElement
+ (instancetype)constant{
    return [[FTUnknownElement alloc]init];
}
-(instancetype)init{
    self = [super init];
    if(self){
        self.importance = INT_MIN;
        self.subtreeStrategy = NodeSubtreeStrategyRecord;
    }
    return self;
}
@end

@implementation FTInvisibleElement

+ (instancetype)constant{
    return [[FTInvisibleElement alloc]init];
}
-(instancetype)init{
    return [self initWithSubtreeStrategy:NodeSubtreeStrategyIgnore];
}
-(instancetype)initWithSubtreeStrategy:(NodeSubtreeStrategy)subtreeStrategy{
    self = [super initWithSubtreeStrategy:subtreeStrategy];
    if(self){
        self.importance = 0;
    }
    return self;
}
@end

@implementation FTIgnoredElement

-(instancetype)initWithSubtreeStrategy:(NodeSubtreeStrategy)subtreeStrategy{
    self = [super initWithSubtreeStrategy:subtreeStrategy];
    if(self){
        self.importance = INT_MAX;
    }
    return self;
}

@end

@implementation FTAmbiguousElement
-(instancetype)init{
    self = [super initWithSubtreeStrategy:NodeSubtreeStrategyRecord];
    self.importance = 0;
    return self;
}
@end

@implementation FTSpecificElement

-(instancetype)initWithSubtreeStrategy:(NodeSubtreeStrategy)subtreeStrategy{
    self = [super initWithSubtreeStrategy:subtreeStrategy];
    if(self){
        self.importance = INT_MAX;
    }
    return self;
}
@end

#endif
