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
//
//  FTCALayerChange.h
//  FTMobileSDK
//
//  Created by hulilei on 2026/3/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_OPTIONS(NSUInteger, FTCALayerChangeAspect) {
    FTCALayerChangeAspectDisplay = 1 << 0,
    FTCALayerChangeAspectDraw    = 1 << 1,
    FTCALayerChangeAspectLayout  = 1 << 2
};

@interface FTCALayerChange : NSObject
@property (nonatomic, weak, readonly) CALayer *layer;
@property (nonatomic, assign) FTCALayerChangeAspect aspects;

- (instancetype)initWithLayer:(CALayer *)layer aspects:(FTCALayerChangeAspect)aspects;
@end

NS_ASSUME_NONNULL_END

#endif
