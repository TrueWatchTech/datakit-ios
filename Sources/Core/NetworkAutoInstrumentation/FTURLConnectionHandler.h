//
//  FTURLConnectionHandler.h
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
#import "FTURLSessionInterceptorProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class FTURLConnectionInstrumentation;

typedef NS_ENUM(NSUInteger, FTURLConnectionHandlerState) {
    FTURLConnectionHandlerStatePrepared,
    FTURLConnectionHandlerStateStarted,
    FTURLConnectionHandlerStateTerminal,
};

/// Per-request state for NSURLConnection automatic Resource and Trace instrumentation.
NS_EXTENSION_UNAVAILABLE("NSURLConnection automatic instrumentation is not supported in app extensions.")
@interface FTURLConnectionHandler : NSObject

@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, assign, readonly) FTURLConnectionHandlerState state;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly, nullable) NSDictionary<NSString *, NSString *> *injectedTraceHeaders;
@property (nonatomic, copy, readonly, nullable) NSString *traceID;
@property (nonatomic, copy, readonly, nullable) NSString *spanID;
@property (nonatomic, weak, nullable) FTURLConnectionInstrumentation *instrumentation;
@property (nonatomic, assign) NSUInteger generation;

- (instancetype)initWithRequest:(NSURLRequest *)request
                 resourceEnabled:(BOOL)resourceEnabled
                        provider:(nullable ResourcePropertyProvider)provider
                     errorFilter:(nullable SessionTaskErrorFilter)errorFilter
              rumResourceHandler:(nullable id<FTRumResourceProtocol>)rumResourceHandler;

- (BOOL)recordStartWithDate:(NSDate *)date continuousTime:(uint64_t)continuousTime;
- (void)activate;
- (void)discard;
- (void)didReceiveResponse:(NSURLResponse *)response;
- (void)didReceiveData:(NSData *)data;
- (void)didSendBodyDataWithTotalBytesWritten:(long long)totalBytesWritten;
- (void)updateRequest:(NSURLRequest *)request
               traceID:(nullable NSString *)traceID
                spanID:(nullable NSString *)spanID
  injectedTraceHeaders:(nullable NSDictionary<NSString *, NSString *> *)injectedTraceHeaders;
/// Atomically applies redirect security policy and updates the final Resource request snapshot.
- (NSURLRequest *)requestByPreparingRedirectRequest:(NSURLRequest *)request;
- (BOOL)recordTerminalWithResponse:(nullable NSURLResponse *)response
                              error:(nullable NSError *)error
                               date:(NSDate *)date
                     continuousTime:(uint64_t)continuousTime;

/// These methods are called only from the instrumentation processing queue.
- (void)reportStartIfNeeded;
- (void)reportTerminalIfNeeded;

@end

NS_ASSUME_NONNULL_END
