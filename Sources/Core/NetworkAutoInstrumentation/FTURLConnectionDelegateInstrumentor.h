//
//  FTURLConnectionDelegateInstrumentor.h
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
/// Hooks a non-nil delegate in place. Missing observations receive defaults on
/// the original class, like URLSession. No ISA change or forwarding proxy is used.
/// Root/proxy/download-only and forwarded-observation delegates are unsupported.
NS_EXTENSION_UNAVAILABLE("NSURLConnection automatic instrumentation is not supported in app extensions.")
@interface FTURLConnectionDelegateInstrumentor : NSObject

+ (BOOL)instrumentDelegate:(id)delegate;

/// Internal observer guard: observe an inherited callback chain only once.
+ (BOOL)shouldObserveDelegate:(id)delegate connection:(NSURLConnection *)connection selector:(SEL)selector;

@end
#pragma clang diagnostic pop

NS_ASSUME_NONNULL_END
