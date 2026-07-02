#import <TargetConditionals.h>
#if TARGET_OS_IOS
//
//  FTSessionReplayCoreImports.h
//  FTSessionReplay
//
//  Created by hulilei on 2026/4/8.
//

#pragma once

#if defined(SWIFT_PACKAGE)
@import _GuanceSDKCore;
#else
#import "Sources/Core/BaseUtils/Base/FTBaseInfoHandler.h"
#import "Sources/Core/BaseUtils/Base/FTConstants.h"
#import "Sources/Core/BaseUtils/Base/FTDateUtil.h"
#import "Sources/Core/BaseUtils/Base/FTInnerLog.h"
#import "Sources/Core/BaseUtils/Base/FTJSONUtil.h"
#import "Sources/Core/BaseUtils/Base/FTNetworkConnectivity.h"
#import "Sources/Core/BaseUtils/Base/FTPresetProperty.h"
#import "Sources/Core/BaseUtils/Base/FTReadWriteHelper.h"
#import "Sources/Core/BaseUtils/Base/NSDate+FTUtil.h"
#import "Sources/Core/BaseUtils/Swizzle/FTSwizzler.h"
#import "Sources/Core/BaseUtils/Thread/include/FTThreadDispatchManager.h"
#import "Sources/Core/DataManager/FTTrackDataManager.h"
#import "Sources/Core/DataManager/Upload/FTHTTPClient.h"
#import "Sources/Core/DataManager/Upload/FTNetworkInfoManager.h"
#import "Sources/Core/DataManager/Upload/FTRequest.h"
#import "Sources/Core/DataManager/Upload/FTRequestBody.h"
#import "Sources/Core/FTWKWebView/FTWKWebViewHandler.h"
#import "Sources/Core/Protocol/FTMessageReceiver.h"
#import "Sources/Core/Protocol/FTModuleManager.h"
#import "Sources/Core/Protocol/FTSRWebTrackingProtocol.h"
#import "Sources/Core/RemoteConfig/FTRemoteConfigManager.h"
#import "Sources/Core/RemoteConfig/FTRemoteConfigModel.h"
#endif

#endif
