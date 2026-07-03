//
//  FTUITextViewRecorder.h
//  SessionReplay
//
//  Created by hulilei on 2023/8/30.
//
//  Copyright 2023 Shanghai Guance Information Technology Co., Ltd.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FTSRNodeWireframesBuilder.h"

@class FTViewAttributes, FTSRColorSnapshot;
@protocol FTSRTextObfuscatingProtocol;
NS_ASSUME_NONNULL_BEGIN
typedef id<FTSRTextObfuscatingProtocol>_Nullable(^FTTextViewObfuscator)(FTViewTreeRecordingContext *context,FTViewAttributes *attributes,BOOL isSensitive,BOOL isEditable);
@interface FTUITextViewBuilder:NSObject<FTSRNodeWireframesBuilder>
@property (nonatomic, assign) int wireframeID;
@property (nonatomic, strong) FTViewAttributes *attributes;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong, nullable) FTSRColorSnapshot * textColor;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGRect contentRect;
@property (nonatomic, strong) id<FTSRTextObfuscatingProtocol> textObfuscator;
@end
@interface FTUITextViewRecorder : NSObject<FTSRWireframesRecorder>
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic,copy) FTTextViewObfuscator textObfuscator;

@end

NS_ASSUME_NONNULL_END

#endif
