//
//  FTURLConnectionDelegate.h
//  FTMobileSDK
//
//  Copyright 2026 TRUEWATCH TECHNOLOGY INC PTE. LTD.
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/// Default observer installed when the application's NSURLConnection delegate is nil.
/// Only observes Resource callbacks; authentication, cache, and body-stream decisions
/// remain with Foundation. These methods also serve as hook observer implementations;
/// they resolve state from the connection and never access delegate ivars.
NS_EXTENSION_UNAVAILABLE("NSURLConnection automatic instrumentation is not supported in app extensions.")
@interface FTURLConnectionDelegate : NSObject <NSURLConnectionDataDelegate>

@end
#pragma clang diagnostic pop

NS_ASSUME_NONNULL_END
