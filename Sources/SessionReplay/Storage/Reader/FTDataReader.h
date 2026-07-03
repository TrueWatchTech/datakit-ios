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
//  FTDataReader.h
//  FTMobileSDK
//
//  Created by hulilei on 2024/6/21.
//

#import <Foundation/Foundation.h>
#import "FTReader.h"
NS_ASSUME_NONNULL_BEGIN
@interface FTDataReader : NSObject<FTReader>
-(instancetype)initWithQueue:(dispatch_queue_t)queue fileReader:(id<FTReader>)fileReader;
@end

NS_ASSUME_NONNULL_END

#endif
