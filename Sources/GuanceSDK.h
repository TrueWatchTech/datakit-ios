#ifndef GuanceSDK_h
#define GuanceSDK_h

#import <Foundation/Foundation.h>

//! Project version number for GuanceSDK.
FOUNDATION_EXPORT double GuanceSDKVersionNumber;

//! Project version string for GuanceSDK.
FOUNDATION_EXPORT const unsigned char GuanceSDKVersionString[];

#import <GuanceSDK/FTMobileConfig.h>
#import <GuanceSDK/FTExternalDataManager.h>
#import <GuanceSDK/FTResourceMetricsModel.h>
#import <GuanceSDK/FTResourceContentModel.h>
#import <GuanceSDK/FTURLSessionDelegate.h>
#import <GuanceSDK/FTURLSessionInterceptor.h>
#import <GuanceSDK/FTTraceManager.h>
#import <GuanceSDK/FTLogger.h>
#import <GuanceSDK/FTMobileAgent.h>
#import <GuanceSDK/FTRumDatasProtocol.h>
#import <GuanceSDK/FTLog.h>
#import <GuanceSDK/FTTraceContext.h>
#import <GuanceSDK/FTLoggerConfig.h>
#import <GuanceSDK/FTRumConfig.h>
#import <GuanceSDK/FTConstants.h>
#import <GuanceSDK/FTWKWebViewHandler.h>
#import <GuanceSDK/FTMobileConfig+Private.h>
#import <GuanceSDK/FTActionTrackingHandler.h>
#import <GuanceSDK/FTViewTrackingHandler.h>
#import <GuanceSDK/FTRUMView.h>
#import <GuanceSDK/FTRUMAction.h>

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV
#import <GuanceSDK/FTDefaultActionTrackingHandler.h>
#import <GuanceSDK/FTDefaultUIKitViewTrackingHandler.h>
#endif
#import <GuanceSDK/FTExtensionConfig.h>
#import <GuanceSDK/FTExtensionManager.h>
#import <GuanceSDK/FTPackageIdGenerator.h>
#import <GuanceSDK/FTRecordModel.h>
#import <GuanceSDK/FTRequest.h>
#import <GuanceSDK/FTRequestBody.h>
#import <GuanceSDK/FTSerialNumberGenerator.h>
#import <GuanceSDK/FTMobileSDK.h>

#endif /* GuanceSDK_h */
