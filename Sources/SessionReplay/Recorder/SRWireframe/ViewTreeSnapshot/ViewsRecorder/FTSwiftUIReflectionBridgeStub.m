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

#if TARGET_OS_IOS && defined(GUANCE_COCOAPODS)

#import "FTSwiftUIReflectionBridge.h"

@implementation FTSwiftUIRecordingAttributes
@end

@implementation FTSwiftUIRecordingResult

- (NSArray *)wireframes {
    return @[];
}

- (NSArray *)resources {
    return @[];
}

@end

@implementation FTSwiftUIRenderer
@end

@implementation FTSwiftUIRecordingBuilder

- (nullable FTSwiftUIRecordingResult *)build {
    return nil;
}

@end

@implementation FTSwiftUIReflectionBridge

- (FTSwiftUIRecordingAttributes *)makeRecordingAttributes API_AVAILABLE(ios(13.0)) {
    return [FTSwiftUIRecordingAttributes new];
}

- (nullable FTSwiftUIRenderer *)rendererForHostingView:(UIView *)view API_AVAILABLE(ios(13.0)) {
    return nil;
}

- (nullable FTSwiftUIRecordingBuilder *)recordingBuilderForRenderer:(FTSwiftUIRenderer *)renderer attributes:(FTSwiftUIRecordingAttributes *)attributes API_AVAILABLE(ios(13.0)) {
    return nil;
}

@end

#endif
