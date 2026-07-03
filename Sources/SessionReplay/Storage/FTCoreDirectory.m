//
//  FTCoreDirectory.m
//  SessionReplay
//
//  Created by hulilei on 2026/6/4.
//
//  Copyright 2026 Shanghai Guance Information Technology Co., Ltd.
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

#import "FTCoreDirectory.h"
#import "FTDirectory.h"
#import "FTFeatureDirectories.h"

@implementation FTCoreDirectory

- (instancetype)initWithDirectory:(FTDirectory *)directory{
    self = [super init];
    if (self) {
        _directory = directory;
    }
    return self;
}

- (instancetype)initWithSubdirectoryPath:(NSString *)path{
    return [self initWithDirectory:[[FTDirectory alloc]initWithSubdirectoryPath:path]];
}

- (FTFeatureDirectories *)featureDirectoriesForFeatureName:(NSString *)featureName{
    FTDirectory *granted = [self.directory createSubdirectoryWithPath:featureName];
    if (!granted) {
        return nil;
    }
    FTDirectory *pending = [self.directory createSubdirectoryWithPath:[featureName stringByAppendingString:@".pending"]];
    FTDirectory *errorSampled = [self.directory createSubdirectoryWithPath:[featureName stringByAppendingString:@".cache"]];
    return [[FTFeatureDirectories alloc]initWithGranted:granted
                                                pending:pending
                                           errorSampled:errorSampled];
}

@end

#endif
