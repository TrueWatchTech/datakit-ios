//
//  NSTabView+FTAutoTrack.m
//  FTSDK
//
//  Created by hulilei on 2021/9/26.
//

#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import "NSTabView+FTAutoTrack.h"
#import "FTSwizzler.h"
#import "FTGlobalRumManager.h"
#import "NSView+FTAutoTrack.h"
#import "FTInnerLog.h"
#import "FTAutoTrack.h"
@implementation NSTabView (FTAutoTrack)
static void *FTMacTabViewDidSelectKey = &FTMacTabViewDidSelectKey;
-(NSString *)datakit_actionName{
    if(self.selectedTabViewItem.label.length>0){
        return [NSString stringWithFormat:@"[%@]%@",NSStringFromClass(self.class),self.selectedTabViewItem.label];
    }
    NSInteger index = [self indexOfTabViewItem:self.selectedTabViewItem];
    if(index != NSNotFound){
        return [NSString stringWithFormat:@"[%@]selectedIndex:%ld",NSStringFromClass(self.class),(long)index];
    }
    return [NSString stringWithFormat:@"[%@]",NSStringFromClass(self.class)];
}
-(void)datakit_setDelegate:(id<NSTabViewDelegate>)delegate{
    [self datakit_setDelegate:delegate];
    if (self.delegate == nil) {
        return;
    }
    SEL selector = @selector(tabView:didSelectTabViewItem:);
    Class class = [FTSwizzler realDelegateClassFromSelector:selector proxy:delegate];
    
    if ([FTSwizzler realDelegateClass:class respondsToSelector:selector]) {
        FTSwizzlerInstanceMethod(class,
                                 selector,
                                 FTSWReturnType(void),
                                 FTSWArguments(NSTabView *tabView, NSTabViewItem *tabViewItem),
                                 FTSWReplacement({
            FTSWCallOriginal(tabView, tabViewItem);
            if (tabView && tabViewItem) {
                [[FTAutoTrack sharedInstance] trackActionWithName:tabView.datakit_actionName];
            }
        }), FTSwizzlerModeOncePerClassAndSuperclasses, FTMacTabViewDidSelectKey);
    }
    
}

@end
#endif
