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
//
//  FTWKWebViewRecorder.h
//  FTMobileSDK
//
//  Created by hulilei on 2025/4/18.
//
#if !TARGET_OS_TV
#import <Foundation/Foundation.h>
#import "FTSRNodeWireframesBuilder.h"

NS_ASSUME_NONNULL_BEGIN
@class FTViewAttributes;

@interface FTWKWebViewBuilder : NSObject<FTSRNodeWireframesBuilder>
@property (nonatomic, assign) int64_t wireframeID;
@property (nonatomic, assign) int64_t slotID;
@property (nonatomic, strong) FTViewAttributes *attributes;
@property (nonatomic, strong, nullable) NSDictionary *linkRUMKeysInfo;
@end

@interface FTWKWebViewRecorder : NSObject<FTSRWireframesRecorder>
@property (nonatomic, copy) NSString *identifier;
@end

NS_ASSUME_NONNULL_END
#endif

#endif
