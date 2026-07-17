//
//  UIScrollView+FTAutoTrack.m
//  FTMobileAgent
//
//  Created by hulilei on 2021/7/28.
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

#import <TargetConditionals.h>
#if TARGET_OS_IOS || TARGET_OS_TV
#import "UIScrollView+FTAutoTrack.h"
#import "FTSwizzler.h"
#import "FTAutoTrackHandler.h"
#import "UIView+FTAutoTrack.h"
#import "FTConstants.h"

static void *const kFTCollectionViewDidSelect = (void *)&kFTCollectionViewDidSelect;
static void *const kFTTableViewDidSelect = (void *)&kFTTableViewDidSelect;

@implementation UITableView (FTAutoTrack)

- (void)ft_setDelegate:(id <UITableViewDelegate>)delegate {
    [self ft_setDelegate:delegate];
    if (self.delegate == nil) {
        return;
    }
    SEL selector = @selector(tableView:didSelectRowAtIndexPath:);
    Class class = [FTSwizzler realDelegateClassFromSelector:selector proxy:delegate];
    
    if ([FTSwizzler realDelegateClass:class respondsToSelector:selector]) {
        FTSwizzlerInstanceMethod(class,
                                 selector,
                                 FTSWReturnType(void),
                                 FTSWArguments(UITableView *tableView, NSIndexPath * indexPath),
                                 FTSWReplacement({
                                                     if (tableView && indexPath) {
                                                         UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                                         id<FTUIEventHandler> actionHandler = [FTAutoTrackHandler sharedInstance].actionHandler;
                                                         if(actionHandler  && [actionHandler respondsToSelector:@selector(notify_sendAction:)]){
                                                             [actionHandler notify_sendAction:cell];
                                                         }
                                                     }
                                                     FTSWCallOriginal(tableView, indexPath);
                                                     
                                                 }),
                                 FTSwizzlerModeOncePerClassAndSuperclasses, 
                                 kFTTableViewDidSelect);
    }
}

@end


@implementation UICollectionView (FTAutoTrack)

- (void)ft_setDelegate:(id <UICollectionViewDelegate>)delegate {
    [self ft_setDelegate:delegate];
    
    if (self.delegate == nil) {
        return;
    }
    SEL selector = @selector(collectionView:didSelectItemAtIndexPath:);
    Class class = [FTSwizzler realDelegateClassFromSelector:selector proxy:delegate];
    
    if ([FTSwizzler realDelegateClass:class respondsToSelector:selector]) {
        FTSwizzlerInstanceMethod(class,
                                 selector,
                                 FTSWReturnType(void),
                                 FTSWArguments(UICollectionView * collectionView, NSIndexPath * indexPath),
                                 FTSWReplacement({
                                                     if (collectionView && indexPath) {
                                                         UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
                                                         id<FTUIEventHandler> actionHandler = [FTAutoTrackHandler sharedInstance].actionHandler;
                                                         if(actionHandler  && [actionHandler respondsToSelector:@selector(notify_sendAction:)]){
                                                             [actionHandler notify_sendAction:cell];
                                                         }
                                                     }
                                                     FTSWCallOriginal(collectionView, indexPath);
                                                 }),
                                 FTSwizzlerModeOncePerClassAndSuperclasses,
                                 kFTCollectionViewDidSelect);
    }
    
}
@end

#endif
