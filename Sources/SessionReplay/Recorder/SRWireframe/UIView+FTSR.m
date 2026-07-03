//
//  UIView+FTSR.m
//  SessionReplay
//
//  Created by hulilei on 2023/8/3.
//
//  Copyright 2023 Shanghai Guance Information Technology Co., Ltd.
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
#if TARGET_OS_IOS

#import "UIView+FTSR.h"
#import <objc/runtime.h>

static char *associatedNodeIDKey = "FTSRNodeIDKey";
static char *associatedNodeIDsKey = "FTSRNodeIDsKey";

@implementation UIView (FTSR)

-(void)setSRNodeID:(NSDictionary *)nodeID{
    objc_setAssociatedObject(self, &associatedNodeIDKey, nodeID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSDictionary *)SRNodeID{
    return objc_getAssociatedObject(self, &associatedNodeIDKey);
}
-(NSDictionary *)SRNodeIDs{
    return  objc_getAssociatedObject(self, &associatedNodeIDsKey);
}
-(void)setSRNodeIDs:(NSDictionary *)nodeIDs{
    objc_setAssociatedObject(self, &associatedNodeIDsKey, nodeIDs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)usesDarkMode{
    if (@available(iOS 12.0, *)) {
        return self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark;
    } else {
        return NO;
    }
}
@end

#endif
