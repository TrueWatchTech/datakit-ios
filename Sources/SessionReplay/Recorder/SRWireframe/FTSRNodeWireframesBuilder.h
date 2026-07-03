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
//
//  FTSRNodeWireframesBuilder.h
//  FTMobileSDK
//
//  Created by hulilei on 2023/8/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FTSRWireframe,FTViewAttributes,FTViewTreeRecordingContext,FTSRNodeSemantics,FTSessionReplayWireframesBuilder;
@protocol FTSRTextObfuscatingProtocol;

typedef FTSRNodeSemantics* _Nullable(^SemanticsOverride)(UIView *  view, FTViewAttributes* attributes);
typedef id<FTSRTextObfuscatingProtocol> _Nullable(^FTTextObfuscator)(FTViewTreeRecordingContext *context,FTViewAttributes *attributes);

@protocol FTSRNodeWireframesBuilder <NSObject>
- (FTViewAttributes*)attributes;
- (CGRect)wireframeRect;
- (NSArray<FTSRWireframe *>*)buildWireframesWithBuilder:(FTSessionReplayWireframesBuilder *)builder;;
@end

@protocol FTSRWireframesRecorder <NSObject>
@property (nonatomic, copy) NSString *identifier;
-(nullable FTSRNodeSemantics *)recorder:(UIView *)view attributes:(FTViewAttributes *)attributes context:(FTViewTreeRecordingContext *)context;
@end

@protocol FTSRResource <NSObject>
@property (nonatomic, copy) NSString *mimeType;
- (NSString *)calculateIdentifier;
- (NSData *)calculateData;
@end
NS_ASSUME_NONNULL_END

#endif
