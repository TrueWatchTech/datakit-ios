//
//  FTResourceAutoTrace.m
//  FTMobileSDKUnitTests
//
//  Created by hulilei on 2024/1/24.
//  Copyright © 2024 TRUEWATCH. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "XCTestCase+Utils.h"
#import "FTModelHelper.h"
#import "FTGlobalRumManager.h"
#import "FTTrackerEventDBTool.h"
#import "FTConstants.h"
#import "FTRUMManager.h"
#import "TestSessionDelegate.h"
#import "FTMobileAgent.h"
#import "FTTrackerEventDBTool.h"
#import "NSDate+FTUtil.h"
#import "FTSessionConfiguration.h"
#import "FTURLSessionInstrumentation.h"
#import "OHHTTPStubs.h"
@interface FTResourceAutoTrace : XCTestCase

@end

@implementation FTResourceAutoTrace

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[FTSessionConfiguration defaultConfiguration] load];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [FTMobileAgent shutDown];
    [FTMobileAgent clearAllData];
    [[FTSessionConfiguration defaultConfiguration] unload];

}
- (void)initSDKWithEnableAutoTraceResource:(BOOL)enable{
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *url = [processInfo environment][@"ACCESS_SERVER_URL"];
    NSString *appid = [processInfo environment][@"APP_ID"];
    FTMobileConfig *config = [[FTMobileConfig alloc]initWithDatakitUrl:url];
    config.autoSync = NO;
    FTRumConfig *rumConfig = [[FTRumConfig alloc]initWithAppid:appid];
    rumConfig.enableTraceUserResource = enable;
    [FTMobileAgent startWithConfigOptions:config];
    [[FTMobileAgent sharedInstance] startRumWithConfigOptions:rumConfig];
}
- (void)testAutoTraceResource_NoDelegate{
    [self initSDKWithEnableAutoTraceResource:YES];
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    [self networkUploadHandler:nil trace:YES completionHandler:^(NSURLResponse *response, NSError *error) {
        [expectation fulfill];
    }];
}
- (void)testDisableAutoTraceResource_NoDelegate{
    [self initSDKWithEnableAutoTraceResource:NO];
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    [self networkUploadHandler:nil trace:NO completionHandler:^(NSURLResponse *response, NSError *error) {
        [expectation fulfill];
    }];
}
- (void)testURLSessionCreateBeforeSDKInit_NoDelegate{
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [self initSDKWithEnableAutoTraceResource:YES];
    [self networkUploadHandlerSession:session autoTrace:YES completionHandler:^(NSURLResponse *response, NSError *error) {
        [expectation fulfill];
    }];
}
- (void)testAutoTraceResource_DelegateNoneMethod{
    [self initSDKWithEnableAutoTraceResource:YES];
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate_None *delegate = [[TestSessionDelegate_None alloc]init];
    [self networkUploadHandler:delegate trace:YES completionHandler:^(NSURLResponse *response, NSError *error) {
        [expectation fulfill];
    }];
}
- (void)testDisableAutoTraceResource_DelegateNoneMethod{
    [self initSDKWithEnableAutoTraceResource:NO];
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate_None *delegate = [[TestSessionDelegate_None alloc]init];
    [self networkUploadHandler:delegate trace:NO completionHandler:^(NSURLResponse *response, NSError *error) {
        [expectation fulfill];
    }];
}
- (void)testURLSessionCreateBeforeSDKInit_DelegateNoneMethod{
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate_None *delegate = [[TestSessionDelegate_None alloc]init];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:delegate delegateQueue:nil];
    [self initSDKWithEnableAutoTraceResource:YES];
    [self networkUploadHandlerSession:session autoTrace:YES completionHandler:^(NSURLResponse *response, NSError *error) {
        [expectation fulfill];
    }];
}
- (void)testAutoTraceResource_DelegateAllMethod{
    [self initSDKWithEnableAutoTraceResource:YES];
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate *delegate = [[TestSessionDelegate alloc]initWithCompletionHandler:^{
        [expectation fulfill];
    }];
    [self networkUploadHandler:delegate trace:YES completionHandler:nil];
}
- (void)testDisableAutoTraceResource_DelegateAllMethod{
    [self initSDKWithEnableAutoTraceResource:NO];
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate *delegate = [[TestSessionDelegate alloc]initWithCompletionHandler:^{
        [expectation fulfill];
    }];
    [self networkUploadHandler:delegate trace:NO completionHandler:nil];
}
- (void)testURLSessionCreateBeforeSDKInit_DelegateAllMethod{
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate *delegate = [[TestSessionDelegate alloc]initWithCompletionHandler:^{
        [expectation fulfill];
    }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:delegate delegateQueue:nil];
    [self initSDKWithEnableAutoTraceResource:YES];
    [self networkUploadHandlerSession:session autoTrace:YES completionHandler:nil];
}
- (void)testAutoTraceResource_DelegateNoCollectingMetrics{
    [self initSDKWithEnableAutoTraceResource:YES];
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate_NoCollectingMetrics *delegate = [[TestSessionDelegate_NoCollectingMetrics alloc]initWithCompletionHandler:^{
        [expectation fulfill];
    }];
    [self networkUploadHandler:delegate trace:YES completionHandler:nil];
}
- (void)testDisableAutoTraceResource_DelegateNoCollectingMetrics{
    [self initSDKWithEnableAutoTraceResource:NO];
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate_NoCollectingMetrics *delegate = [[TestSessionDelegate_NoCollectingMetrics alloc]initWithCompletionHandler:^{
        [expectation fulfill];
    }];
    [self networkUploadHandler:delegate trace:NO completionHandler:nil];
}
- (void)testURLSessionCreateBeforeSDKInit_DelegateNoCollectingMetrics{
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate_NoCollectingMetrics *delegate = [[TestSessionDelegate_NoCollectingMetrics alloc]initWithCompletionHandler:^{
        [expectation fulfill];
    }];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:delegate delegateQueue:nil];
    [self initSDKWithEnableAutoTraceResource:YES];
    [self networkUploadHandlerSession:session autoTrace:YES completionHandler:nil];
}
- (void)testAutoTraceResource_DelegateOnlyCollectingMetrics{
    [self initSDKWithEnableAutoTraceResource:YES];
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate_OnlyCollectingMetrics *delegate = [[TestSessionDelegate_OnlyCollectingMetrics alloc]init];
    [self networkUploadHandler:delegate trace:YES completionHandler:^(NSURLResponse *response, NSError *error) {
        [expectation fulfill];
    }];
   
}
- (void)testDisableAutoTraceResource_DelegateOnlyCollectingMetrics{
    [self initSDKWithEnableAutoTraceResource:NO];
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate_OnlyCollectingMetrics *delegate = [[TestSessionDelegate_OnlyCollectingMetrics alloc]init];
    [self networkUploadHandler:delegate trace:NO completionHandler:^(NSURLResponse *response, NSError *error) {
        [expectation fulfill];
    }];
}
- (void)testIsNotSDKURL{
    // When SDK URL has port number
    NSString *sdkURLStr = @"http://www.test.com:9529";
    [[FTURLSessionInstrumentation sharedInstance] setSdkUrlStr:sdkURLStr serviceName:@"test"];
    
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:nil] == NO);
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:[NSURL URLWithString:@"http://www.test.com:9529/v1/write/rum"]] == NO);
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:[NSURL URLWithString:@"http://www.test.com"]] == YES);
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:[NSURL URLWithString:@"http://www.test.com:9528"]] == YES);
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:[NSURL URLWithString:@"http://www.test.com/v1/write/rum"]] == YES);
    
    [[FTURLSessionInstrumentation sharedInstance] shutDown];
    
    // When SDK URL has no port number
    NSString *sdkURLStr2 = @"http://www.test.com";
    [[FTURLSessionInstrumentation sharedInstance] setSdkUrlStr:sdkURLStr2 serviceName:@"test"];
    
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:nil] == NO);
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:[NSURL URLWithString:@"http://www.test.com/v1/write/rum"]] == NO);
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:[NSURL URLWithString:@"http://www.test.com"]] == NO);
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:[NSURL URLWithString:@"http://www.test.com:9528"]] == YES);
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:[NSURL URLWithString:@"http://www.test.com:9529/v1/write/rum"]] == YES);
    
    [[FTURLSessionInstrumentation sharedInstance] shutDown];
    
    
    // When SDK URL is not set
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:nil] == NO);
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:[NSURL URLWithString:@"http://www.test.com/v1/write/rum"]] == NO);
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:[NSURL URLWithString:@"http://www.test.com"]] == NO);
    XCTAssertTrue([[FTURLSessionInstrumentation sharedInstance] isNotSDKInsideUrl:[NSURL URLWithString:@"http://www.test.com:9528"]] == NO);

    [[FTURLSessionInstrumentation sharedInstance] shutDown];
    
   
}
- (void)testURLSessionCreateBeforeSDKInit_DelegateOnlyCollectingMetrics{
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    TestSessionDelegate_OnlyCollectingMetrics *delegate = [[TestSessionDelegate_OnlyCollectingMetrics alloc]init];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:delegate delegateQueue:nil];
    [self initSDKWithEnableAutoTraceResource:YES];
    [self networkUploadHandlerSession:session autoTrace:YES completionHandler:^(NSURLResponse *response, NSError *error) {
        [expectation fulfill];
    }];
}
- (void)networkUploadHandler:(id<NSURLSessionDelegate>)delegate trace:(BOOL)trace completionHandler:(void (^)(NSURLResponse *response,NSError *error))completionHandler{
    NSURLSession *session;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

    if(delegate){
        session = [NSURLSession sessionWithConfiguration:config delegate:delegate delegateQueue:nil];
    } else {
        session = [NSURLSession sessionWithConfiguration:config];
    }
    [self networkUploadHandlerSession:session autoTrace:trace completionHandler:completionHandler];
}
- (void)networkUploadHandlerSession:(NSURLSession *)session autoTrace:(BOOL)trace completionHandler:(void (^)(NSURLResponse *response,NSError *error))completionHandler{
    [FTModelHelper startView];
    [FTModelHelper startAction];
    
    NSString * urlStr = [[NSProcessInfo processInfo] environment][@"TRACE_URL"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLSessionTask *task;
    if(completionHandler){
        task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            completionHandler?completionHandler(response,error):nil;
        }];
    }else{
        task = [session dataTaskWithRequest:request];
    }
    [task resume];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
    [self waitForTimeInterval:0.5];
    [[FTGlobalRumManager sharedInstance].rumManager syncProcess];
    NSArray *newArray = [[FTTrackerEventDBTool sharedManger] getAllDatas];
    __block NSInteger hasResCount = 0;
    [FTModelHelper resolveModelArray:newArray callBack:^(NSString * _Nonnull source, NSDictionary * _Nonnull tags, NSDictionary * _Nonnull fields, BOOL * _Nonnull stop) {
        if ([source isEqualToString:FT_RUM_SOURCE_RESOURCE]) {
            hasResCount ++;
            XCTAssertTrue([fields.allKeys containsObject:FT_KEY_RESOURCE_TCP]);
            
            NSNumber *dnsStart = @0;
            if([fields.allKeys containsObject:FT_KEY_RESOURCE_DNS]){
                XCTAssertTrue([fields.allKeys containsObject:FT_KEY_RESOURCE_DNS_TIME]);
                dnsStart = fields[FT_KEY_RESOURCE_DNS_TIME][FT_KEY_START];
            }
            XCTAssertTrue([fields.allKeys containsObject:FT_KEY_RESOURCE_CONNECT_TIME]);
            NSNumber *connectStart = fields[FT_KEY_RESOURCE_CONNECT_TIME][FT_KEY_START];
            XCTAssertTrue([fields.allKeys containsObject:FT_KEY_RESOURCE_FIRST_BYTE_TIME]);
            NSNumber *firstByteStart = fields[FT_KEY_RESOURCE_FIRST_BYTE_TIME][FT_KEY_START];
            XCTAssertTrue([fields.allKeys containsObject:FT_KEY_RESOURCE_DOWNLOAD_TIME]);
            NSNumber *downloadStart = fields[FT_KEY_RESOURCE_DOWNLOAD_TIME][FT_KEY_START];
            XCTAssertTrue(downloadStart.longValue>firstByteStart.longValue);
            XCTAssertTrue(firstByteStart.longValue>connectStart.longValue);
            XCTAssertTrue(connectStart.longValue>=dnsStart.longValue);
            if ([tags[FT_KEY_RESOURCE_URL] hasPrefix:@"https:"]) {
                XCTAssertTrue([fields.allKeys containsObject:FT_KEY_RESOURCE_SSL]);
                XCTAssertTrue([fields.allKeys containsObject:FT_KEY_RESOURCE_SSL_TIME]);
                NSNumber *sslStart = fields[FT_KEY_RESOURCE_SSL_TIME][FT_KEY_START];
                XCTAssertTrue(firstByteStart.longValue>sslStart.longValue);
                XCTAssertTrue(sslStart.longValue>connectStart.longValue);
            }
        }
    }];
    if(trace){
        XCTAssertTrue(hasResCount==1);
    }else{
        XCTAssertTrue(hasResCount==0);
    }
}
/**
 * verify: No crashes occur when calling network request during SDK shutdown.
 */
- (void)testSDKShutdown{
    id<OHHTTPStubsDescriptor> stubs = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        return [OHHTTPStubsResponse responseWithData:[@"success" dataUsingEncoding:NSUTF8StringEncoding] statusCode:200 headers:nil];
    }];
    [self initSDK];
    XCTestExpectation *exception = [[XCTestExpectation alloc]init];
    dispatch_group_t group = dispatch_group_create();
    NSInteger count = 0;
    __block BOOL isSDKClose = NO;
    for (int i = 0; i<1000; i++) {
        dispatch_group_enter(group);
        dispatch_async(dispatch_queue_create(0, 0), ^{
            [self network:^{
                dispatch_group_leave(group);
            }];
        });
        dispatch_async(dispatch_queue_create(0, 0), ^{
            if(!isSDKClose){
                isSDKClose = YES;
                [FTMobileAgent shutDown];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initSDK];
                isSDKClose = NO;
            });
        });
        count ++;
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [exception fulfill];
    });
    [self waitForExpectations:@[exception]];
    XCTAssertTrue(count == 1000);
    [OHHTTPStubs removeStub:stubs];
    [FTMobileAgent shutDown];
}
- (void)initSDK{
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    NSString *url = [processInfo environment][@"ACCESS_SERVER_URL"];
    NSString *appid = [processInfo environment][@"APP_ID"];
    FTMobileConfig *config = [[FTMobileConfig alloc]initWithDatakitUrl:url];
    config.autoSync = NO;
    FTRumConfig *rumConfig = [[FTRumConfig alloc]initWithAppid:appid];
    rumConfig.enableTraceUserResource = YES;
    [FTMobileAgent startWithConfigOptions:config];
    FTTraceConfig *traceConfig = [[FTTraceConfig alloc]init];
    traceConfig.enableAutoTrace = YES;
    traceConfig.enableLinkRumData = YES;
    [[FTMobileAgent sharedInstance] startRumWithConfigOptions:rumConfig];
    [[FTMobileAgent sharedInstance] startTraceWithConfigOptions:traceConfig];
}
- (void)network:(void (^)(void))callback{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration]];
    NSString * urlStr = [[NSProcessInfo processInfo] environment][@"TRACE_URL"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(callback) callback();
    }];
    [task resume];
    [session finishTasksAndInvalidate];
}
@end
