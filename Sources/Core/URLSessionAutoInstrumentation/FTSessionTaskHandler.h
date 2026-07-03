//
//  FTTraceHandler.h
//  FTMobileAgent
//
//  Created by hulilei on 2021/10/13.
//  Copyright 2021 TRUEWATCH TECHNOLOGY INC PTE. LTD.
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
@class FTResourceContentModel,FTResourceMetricsModel;
/// Handles a single request, binding intercepted data to the format required by RUM
@interface FTSessionTaskHandler : NSObject
/// Unique identifier, used as the identifier for RUM resource processing
@property (nonatomic, copy, readwrite) NSString *identifier;

/// The initial request sent during this interception. It is the request sent by `URLSession`, not the one provided by the user.
@property (nonatomic, copy) NSURLRequest *request;
/// The response received during this interception.
@property (nonatomic, copy) NSURLResponse *response;
/// The local error that occurred during this interception. Returns `nil` if the task completed successfully.
@property (nonatomic, strong) NSError *error;
/// The task data received during this interception. Returns `nil` if the task completed with an error.
@property (nonatomic, strong) NSData *data;
/// Request duration for each stage required by RUM resource (optional)
@property (nonatomic, strong) FTResourceMetricsModel *metricsModel;
/// Basic data required by RUM resource
@property (nonatomic, strong) FTResourceContentModel *contentModel;
/// trace: span_id. Returns `nil` if trace is not enabled or not associated with RUM.
@property (nonatomic, copy) NSString *spanID;
/// trace: trace_id. Returns `nil` if trace is not enabled or not associated with RUM.
@property (nonatomic, copy) NSString *traceID;

/// Initialization method
/// - Parameter identifier: Unique identifier, based on the identifier
-(instancetype)initWithIdentifier:(NSString *)identifier;
/// Request response data
/// - Parameter data: Data received from the request
///
/// Internally, traceHandle will bind the data to contentModel after receiving -taskCompleted
- (void)taskReceivedData:(NSData *)data;

/// Data for each stage of the request
/// - Parameter metrics: Metrics information
///
/// Internally, traceHandle will process the data into a metricsModel that RUM can accept
- (void)taskReceivedMetrics:(NSURLSessionTaskMetrics *)metrics;
- (void)taskReceivedMetrics:(NSURLSessionTaskMetrics *)metrics custom:(BOOL)custom;
/// Request finished
/// - Parameters:
///   - task: Request task
///   - error: Error information
///
/// Organize data and some information from the task into contentModel
- (void)taskCompleted:(NSURLSessionTask *)task error:(nullable NSError *)error;

@end
NS_ASSUME_NONNULL_END
