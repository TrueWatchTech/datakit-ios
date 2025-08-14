//
//  TestWkWebViewHandler.h
//  App
//
//  Created by hulilei on 2021/8/3.
//  Copyright © 2021 TRUEWATCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WKWebView.h>
NS_ASSUME_NONNULL_BEGIN

@interface TestWkWebViewHandler : NSObject<WKNavigationDelegate>
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
