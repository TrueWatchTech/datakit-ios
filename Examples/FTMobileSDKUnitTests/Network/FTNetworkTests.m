//
//  FTNetworkTests.m
//  ft-sdk-iosTestUnitTests
//
//  Created by hulilei on 2019/12/24.
//  Copyright © 2019 hll. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FTMobileAgent.h"
#import "FTTrackerEventDBTool.h"
#import "FTRecordModel.h"
#import "OHHTTPStubs.h"
#import "FTConstants.h"
#import "NSDate+FTUtil.h"
#import "FTJSONUtil.h"
#import "FTRequest.h"
#import "FTHTTPClient.h"
#import "FTModelHelper.h"
#import "FTTrackDataManager.h"
#import "FTModelHelper.h"
#import "FTMobileAgent+Private.h"
#import "FTTrackDataManager+Test.h"
#import "FTDataUploadWorker.h"
#define FT_SDK_COMPILED_FOR_TESTING

typedef NS_ENUM(NSInteger, FTNetworkTestsType) {
    FTNetworkTest          = 0,
    FTNetworkTestBad          = 1,
    FTNetworkTestNoJsonResponse  = 2,
    FTNetworkTestWrongJsonResponse  = 3,
    FTNetworkTestEmptyResponseData,
    FTNetworkTestErrorResponse,
    FTNetworkTestErrorNet,
    FTNetworkTestPageSizeMini,
    FTNetworkTestPageSizeMedium,
    FTNetworkTestPageSizeMax,
    FTNetworkTestPageSizeCustom,
    FTNetworkTestTimeout,
    FTNetworkTestAutoSyncData,

};
@interface FTNetworkTests : XCTestCase
@property (nonatomic, strong) XCTestExpectation *expectation;
@end

@implementation FTNetworkTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [[FTTrackerEventDBTool sharedManger] deleteAllDatas];
}
- (void)tearDown{
    [OHHTTPStubs removeAllStubs];
    [FTMobileAgent shutDown];
}
- (void)setRightConfigWithTestType:(FTNetworkTestsType)type{
    NSString *urlStr = @"http://www.test.com/some/url/string";
    NSString *logUrl = [urlStr stringByAppendingString:@"/v1/write/logging"];
    NSString *rumUrl = [urlStr stringByAppendingString:@"/v1/write/rum"];
    NSString *traceUrl = [urlStr stringByAppendingString:@"/v1/write/tracing"];
    int pageSize = 0;
    switch (type) {
        case FTNetworkTestPageSizeMax:
            pageSize = 50;
            break;
        case FTNetworkTestPageSizeMedium:
            pageSize = 10;
            break;
        case FTNetworkTestPageSizeMini:
            pageSize = 5;
            break;
        case FTNetworkTestPageSizeCustom:
            pageSize = 25;
            break;
        default:
            break;
    }
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        NSString *str =  request.URL.absoluteString;
        BOOL isURL = [str isEqualToString:logUrl] || [str isEqualToString:rumUrl] || [str isEqualToString:traceUrl];
        if(pageSize>0){
            uint8_t sub[1024] = {0};
            NSInputStream *inputStream = request.HTTPBodyStream;
            NSMutableData *body = [[NSMutableData alloc] init];
            [inputStream open];
            while ([inputStream hasBytesAvailable]) {
                NSInteger len = [inputStream read:sub maxLength:1024];
                if (len > 0 && inputStream.streamError == nil) {
                    [body appendBytes:(void *)sub length:len];
                }else{
                    break;
                }
            }
            NSString *bodyStr = [[NSString alloc]initWithData:body encoding:NSUTF8StringEncoding];
            NSArray *array = [bodyStr componentsSeparatedByString:@"\n"];
            XCTAssertTrue(array.count == pageSize);
        }
        return isURL;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        switch (type) {
            case FTNetworkTest:{
                NSString *data  =[FTJSONUtil convertToJsonData:@{@"data":@"Hello World!",@"code":@200}];
                NSData *requestData = [data dataUsingEncoding:NSUTF8StringEncoding];
                return [OHHTTPStubsResponse responseWithData:requestData statusCode:200 headers:nil];
            }
                break;
                
            case FTNetworkTestBad:{
                NSString *data  =[FTJSONUtil convertToJsonData:@{@"data":@"Hello World!",@"code":@200}];
                
                NSData* requestData = [data dataUsingEncoding:NSUTF8StringEncoding];
                return [OHHTTPStubsResponse responseWithData:requestData statusCode:200 headers:nil];
            }
                break;
            case FTNetworkTestNoJsonResponse:{
                NSString *data  =@"Hello World!";
                
                NSData* requestData = [data dataUsingEncoding:NSUTF8StringEncoding];
                return [OHHTTPStubsResponse responseWithData:requestData statusCode:200 headers:nil];
            }
                break;
            case FTNetworkTestWrongJsonResponse:{
                NSString *data  =[FTJSONUtil convertToJsonData:@{@"data":@"Hello World!",@"code":@200}];
                data = [data stringByAppendingString:@"/n/t"];
                NSData* requestData = [data dataUsingEncoding:NSUTF8StringEncoding];
                return [OHHTTPStubsResponse responseWithData:requestData statusCode:200 headers:nil];
            }
                break;
            case FTNetworkTestEmptyResponseData:{
                return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:200 headers:nil];
            }
                break;
            case FTNetworkTestErrorResponse:{
                NSString *data  =[FTJSONUtil convertToJsonData:@{@"data":@"Hello World!",@"code":@500}];
                NSData* requestData = [data dataUsingEncoding:NSUTF8StringEncoding];
                return [OHHTTPStubsResponse responseWithData:requestData statusCode:500 headers:nil];
            }
                break;
            case FTNetworkTestErrorNet:{
                NSError* notConnectedError = [NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorNotConnectedToInternet userInfo:nil];
                return [OHHTTPStubsResponse responseWithError:notConnectedError];
            }
                break;
            case FTNetworkTestTimeout:{
                sleep(3);
                return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:200 headers:nil];
            }
            default:
                return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:200 headers:nil];
                break;
        }
        
    }];
    if (urlStr) {
        FTMobileConfig *config = [[FTMobileConfig alloc]initWithDatakitUrl:urlStr];
        config.autoSync = (type == FTNetworkTestAutoSyncData);
        config.syncPageSize = pageSize>0?pageSize:10;
        config.enableSDKDebugLog = YES;
        [FTMobileAgent startWithConfigOptions:config];
        if(type == FTNetworkTestAutoSyncData){
            FTRumConfig *rum = [[FTRumConfig alloc]initWithAppid:@"Test"];
            [[FTMobileAgent sharedInstance] startRumWithConfigOptions:rum];
        }
        FTTraceConfig *trace = [[FTTraceConfig alloc]init];
        trace.enableAutoTrace = YES;
        [[FTMobileAgent sharedInstance] startTraceWithConfigOptions:trace];
    }
}
/**
 Test if the upload process is correct
 */
-(void)testNetwork{
    
    [self setRightConfigWithTestType:FTNetworkTest];

    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    
    FTRecordModel *model = [FTModelHelper createLogModel:@"FTNetworkTests"];
    FTRequest *request = [FTRequest createRequestWithEvents:@[model] type:FT_DATA_TYPE_LOGGING];
    [[FTHTTPClient new] sendRequest:request completion:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nullable data, NSError * _Nullable error) {
    
        NSInteger statusCode = httpResponse.statusCode;
        BOOL success = (statusCode >=200 && statusCode < 500);
        XCTAssertTrue(success);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
    
}
/**
 Test if the upload process is correct when network status is poor
 */
-(void)testBadNetwork{
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    [self setRightConfigWithTestType:FTNetworkTestBad];
    
    FTRecordModel *model = [FTModelHelper createLogModel:@"testBadNetwork"];

    FTRequest *request = [FTRequest createRequestWithEvents:@[model] type:FT_DATA_TYPE_LOGGING];
    [[FTHTTPClient new] sendRequest:request completion:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nullable data, NSError * _Nullable error) {
    
        NSInteger statusCode = httpResponse.statusCode;
        BOOL success = (statusCode >=200 && statusCode < 500);
        XCTAssertTrue(success);
        [expectation fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
    
}

/**
 Test successful request with non-JSON response format
 */
-(void)testNoJsonResponseNetWork{
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
     [self setRightConfigWithTestType:FTNetworkTestNoJsonResponse];
    FTRecordModel *model = [FTModelHelper createLogModel:@"testNoJsonResponseNetWork"];
    FTRequest *request = [FTRequest createRequestWithEvents:@[model] type:FT_DATA_TYPE_LOGGING];
    [[FTHTTPClient new] sendRequest:request completion:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nullable data, NSError * _Nullable error) {
        NSError *jsonError;
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        NSString *result =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        XCTAssertTrue(jsonError != nil && [result isEqualToString:@"Hello World!"]);
        [expectation fulfill];
        
    }];

    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}
/**
 Test successful request with incorrect JSON response format
 */
- (void)testWrongJsonResponseNetWork{
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    [self setRightConfigWithTestType:FTNetworkTestWrongJsonResponse];
    FTRecordModel *model = [FTModelHelper createLogModel:@"testWrongJsonResponseNetWork"];
    FTRequest *request = [FTRequest createRequestWithEvents:@[model] type:FT_DATA_TYPE_LOGGING];
    [[FTHTTPClient new] sendRequest:request completion:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nullable data, NSError * _Nullable error) {
        NSError *errors;
        [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&errors];
        XCTAssertTrue(errors != nil);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}
/**
 Test successful request with empty response data
 */
- (void)testEmptyResponseDataNetWork{
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    [self setRightConfigWithTestType:FTNetworkTestEmptyResponseData];
    FTRecordModel *model = [FTModelHelper createLogModel:@"testEmptyResponseDataNetWork"];

    FTRequest *request = [FTRequest createRequestWithEvents:@[model] type:FT_DATA_TYPE_LOGGING];
    [[FTHTTPClient new] sendRequest:request completion:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nullable data, NSError * _Nullable error) {
        XCTAssertTrue(data.bytes == 0);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}
/**
 Test successful request with non-200 response code
 */
- (void)testErrorResponse{
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
     [self setRightConfigWithTestType:FTNetworkTestErrorResponse];
    FTRecordModel *model = [FTModelHelper createLogModel:@"testErrorResponse"];

    FTRequest *request = [FTRequest createRequestWithEvents:@[model] type:FT_DATA_TYPE_LOGGING];
    [[FTHTTPClient new] sendRequest:request completion:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nullable data, NSError * _Nullable error) {
        NSInteger statusCode = httpResponse.statusCode;
        XCTAssertFalse(statusCode == 200);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}
/**
 Test network error
 */
- (void)testErrorNet{
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    [self setRightConfigWithTestType:FTNetworkTestErrorNet];
    FTRecordModel *model = [FTModelHelper createLogModel:@"testErrorNet"];

    FTRequest *request = [FTRequest createRequestWithEvents:@[model] type:FT_DATA_TYPE_LOGGING];
    [[FTHTTPClient new] sendRequest:request completion:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nullable data, NSError * _Nullable error) {
        NSInteger statusCode = httpResponse.statusCode;
        XCTAssertFalse(statusCode == 200);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}
- (void)testUploadAll{
    [self setRightConfigWithTestType:FTNetworkTest];
    for (int i = 0 ; i<10; i++) {
       FTRecordModel *logModel = [FTModelHelper createLogModel:[NSString stringWithFormat:@"%d",i]];
        FTRecordModel *rumModel = [FTModelHelper createRumModel];

        [[FTTrackDataManager sharedInstance] addTrackData:logModel type:FTAddDataRUM];
        [[FTTrackDataManager sharedInstance] addTrackData:rumModel type:FTAddDataRUM];
    }
    FTRecordModel *rumModel = [FTModelHelper createRumModel];
    [[FTTrackDataManager sharedInstance] addTrackData:rumModel type:FTAddDataRUM];
    NSInteger count = [[FTTrackerEventDBTool sharedManger] getDatasCount];
    XCTAssertTrue(count == 21);
    self.expectation = [self expectationWithDescription:@"Async operation timeout"];
    NSLog(@"addObserver: current isUploading = %@",[[FTTrackDataManager sharedInstance].dataUploadWorker valueForKey:@"isUploading"]);
    [[FTTrackDataManager sharedInstance].dataUploadWorker addObserver:self forKeyPath:@"isUploading" options:NSKeyValueObservingOptionNew context:nil];
    [[FTTrackDataManager sharedInstance] flushSyncData];

    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        NSLog(@"isUploading = %@",[[FTTrackDataManager sharedInstance].dataUploadWorker valueForKey:@"isUploading"]);
        XCTAssertNil(error);
    }];
    NSInteger newCount = [[FTTrackerEventDBTool sharedManger] getDatasCount];
    XCTAssertTrue(newCount == 0);
    [[FTTrackDataManager sharedInstance].dataUploadWorker removeObserver:self forKeyPath:@"isUploading"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if([keyPath isEqualToString:@"isUploading"]){
        FTTrackDataManager *manager = object;
        NSNumber *isUploading = [manager valueForKey:@"isUploading"];
        if(!isUploading.boolValue){
            [self.expectation fulfill];
            self.expectation = nil;
        }
    }
}
- (void)testPageSize_default{
    [self pageSize:FTNetworkTestPageSizeMedium];
}
- (void)testPageSize_max{
    [self pageSize:FTNetworkTestPageSizeMax];
}
- (void)testPageSize_mini{
    [self pageSize:FTNetworkTestPageSizeMini];
}
- (void)testPageSize_custom_25{
    [self pageSize:FTNetworkTestPageSizeCustom];
}
- (void)testTimeout{
    [self setRightConfigWithTestType:FTNetworkTestTimeout];

    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    
    FTRecordModel *model = [FTModelHelper createLogModel:@"FTNetworkTests"];
    FTRequest *request = [FTRequest createRequestWithEvents:@[model] type:FT_DATA_TYPE_LOGGING];
    FTHTTPClient *networkManager = [[FTHTTPClient alloc]initWithTimeoutIntervalForRequest:2];
    [networkManager sendRequest:request completion:^(NSHTTPURLResponse * _Nonnull httpResponse, NSData * _Nullable data, NSError * _Nullable error) {
        XCTAssertTrue(error.code == -1001);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:8 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
}
- (void)testAutoSyncData{
    [self setRightConfigWithTestType:FTNetworkTestAutoSyncData];
    FTLoggerConfig *loggerConfig = [[FTLoggerConfig alloc]init];
    loggerConfig.enableCustomLog = YES;
    [[FTMobileAgent sharedInstance] startLoggerWithConfigOptions:loggerConfig];
    XCTestExpectation *expectation= [self expectationWithDescription:@"Async operation timeout"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    [self waitForExpectations:@[expectation]];

    [FTModelHelper startView];
    [FTModelHelper addActionWithContext:nil];
    [FTModelHelper addActionWithContext:nil];
    for (int i = 0; i<101; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[FTLogger sharedInstance] info:[NSString stringWithFormat:@"testLongTimeLogCache%d",i] property:nil];
        });
    }
    [[FTMobileAgent sharedInstance] syncProcess];
    NSInteger count = [[FTTrackerEventDBTool sharedManger] getDatasCount];
    XCTAssertTrue(count>0);
    XCTestExpectation *expectation2= [self expectationWithDescription:@"Async operation timeout"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(11 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [expectation2 fulfill];
    });
    [self waitForExpectations:@[expectation2]];
    NSInteger newCount = [[FTTrackerEventDBTool sharedManger] getDatasCount];
    XCTAssertTrue(newCount == 0);
}
- (void)pageSize:(FTNetworkTestsType)type{
    [self setRightConfigWithTestType:type];
    for (int i = 0 ; i<50; i++) {
       FTRecordModel *logModel = [FTModelHelper createLogModel:[NSString stringWithFormat:@"%d",i]];
        FTRecordModel *rumModel = [FTModelHelper createRumModel];

        [[FTTrackDataManager sharedInstance] addTrackData:logModel type:FTAddDataRUM];
        [[FTTrackDataManager sharedInstance] addTrackData:rumModel type:FTAddDataRUM];
    }
    NSInteger count = [[FTTrackerEventDBTool sharedManger] getDatasCount];
    XCTAssertTrue(count == 100);
    self.expectation = [self expectationWithDescription:@"Async operation timeout"];
    FTHTTPClient *httpClient = [[FTTrackDataManager sharedInstance].dataUploadWorker valueForKey:@"httpClient"];
    NSURLSession *session = [httpClient valueForKey:@"session"];
    switch (type) {
        case FTNetworkTestPageSizeMax:
            XCTAssertTrue(session.configuration.timeoutIntervalForRequest == 50);
            break;
        case FTNetworkTestPageSizeMini:
            XCTAssertTrue(session.configuration.timeoutIntervalForRequest == 30);
            break;
        case FTNetworkTestPageSizeMedium:
            XCTAssertTrue(session.configuration.timeoutIntervalForRequest == 30);
            break;
        case FTNetworkTestPageSizeCustom:
            XCTAssertTrue(session.configuration.timeoutIntervalForRequest == 30);
            break;
        default:
            break;
    }
    [[FTTrackDataManager sharedInstance].dataUploadWorker addObserver:self forKeyPath:@"isUploading" options:NSKeyValueObservingOptionNew context:nil];
    [[FTTrackDataManager sharedInstance] flushSyncData];

    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
    NSInteger newCount = [[FTTrackerEventDBTool sharedManger] getDatasCount];
    XCTAssertTrue(newCount == 0);
    [[FTTrackDataManager sharedInstance].dataUploadWorker removeObserver:self forKeyPath:@"isUploading"];
}
- (void)testSyncSleepTime_Max{
    [self syncSleepTime:100];
}
- (void)testSyncSleepTime_Medium{
    [self syncSleepTime:50];
}
- (void)testSyncSleepTime_Min{
    [self syncSleepTime:0];
}
- (void)syncSleepTime:(int)time{
    FTMobileConfig *config = [[FTMobileConfig alloc]initWithDatakitUrl:@"http://www.test.com/some/url/string"];
    config.syncSleepTime = time;
    config.autoSync = NO;
    [FTMobileAgent startWithConfigOptions:config];
    __block NSTimeInterval duration = 0;
    __block NSTimeInterval end = 0;
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        if(end>0){
            duration = ([NSDate timeIntervalSinceReferenceDate] - end)*1000;
            end = 0;
        }
        return YES;
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        end = [NSDate timeIntervalSinceReferenceDate];
        return [OHHTTPStubsResponse responseWithData:[NSData data] statusCode:200 headers:nil];
    }];
    for (int i = 0 ; i<20; i++) {
       FTRecordModel *logModel = [FTModelHelper createLogModel:[NSString stringWithFormat:@"%d",i]];
        [[FTTrackDataManager sharedInstance] addTrackData:logModel type:FTAddDataRUM];
    }
    self.expectation = [self expectationWithDescription:@"Async operation timeout"];
       
    [[FTTrackDataManager sharedInstance].dataUploadWorker addObserver:self forKeyPath:@"isUploading" options:NSKeyValueObservingOptionNew context:nil];
    [[FTTrackDataManager sharedInstance] flushSyncData];

    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        XCTAssertNil(error);
    }];
    NSInteger newCount = [[FTTrackerEventDBTool sharedManger] getDatasCount];
    XCTAssertTrue(newCount == 0);
    XCTAssertTrue(duration>time);
    [[FTTrackDataManager sharedInstance].dataUploadWorker removeObserver:self forKeyPath:@"isUploading"];
}
@end
