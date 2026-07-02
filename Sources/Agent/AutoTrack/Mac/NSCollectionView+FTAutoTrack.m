//
//  NSCollectionView+FTAutoTrack.m
//  GuanceSDK
//
//  Created by hulilei on 2021/9/17.
//

#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import "NSCollectionView+FTAutoTrack.h"
#import "FTSwizzler.h"
#import "FTGlobalRumManager.h"
#import "FTAutoTrack.h"
@implementation NSCollectionView (FTAutoTrack)
static void *FTMacCollectionViewDidSelectKey = &FTMacCollectionViewDidSelectKey;

-(void)datakit_setDelegate:(id<NSCollectionViewDelegate>)delegate{
    [self datakit_setDelegate:delegate];
    
    if (self.delegate == nil) {
        return;
    }
    SEL selector = @selector(collectionView:didSelectItemsAtIndexPaths:);
    Class class = [FTSwizzler realDelegateClassFromSelector:selector proxy:delegate];
    
    if ([FTSwizzler realDelegateClass:class respondsToSelector:selector]) {
        FTSwizzlerInstanceMethod(class,
                                 selector,
                                 FTSWReturnType(void),
                                 FTSWArguments(NSCollectionView *collectionView, NSSet<NSIndexPath *> *indexPaths),
                                 FTSWReplacement({
            FTSWCallOriginal(collectionView, indexPaths);
            // When getting view's viewcontroller, don't consider NSCollectionViewItem
            if (collectionView && indexPaths) {
                NSIndexPath *indexpath = [[indexPaths allObjects] firstObject];
                NSCollectionViewItem *item = [collectionView itemAtIndexPath:indexpath];
                NSString *actionName = [NSString stringWithFormat:@"[%@][section:%ld][item:%ld]",NSStringFromClass(collectionView.class),(long)indexpath.section,(long)indexpath.item];
                if(item.title.length>0){
                    actionName = [NSString stringWithFormat:@"[%@]%@",NSStringFromClass(collectionView.class),item.title];
                }
                [[FTAutoTrack sharedInstance] trackActionWithName:actionName];
            }
        }), FTSwizzlerModeOncePerClassAndSuperclasses, FTMacCollectionViewDidSelectKey);
    }
    
    
}
@end
@implementation NSTableView (FTAutoTrack)

-(NSString *)datakit_actionName{
    if(self.clickedRow<0 && self.clickedColumn<0){
        return nil;
    }
    NSString *title = nil;
    NSInteger clickedColumn = self.clickedColumn>=0?self.clickedColumn:0;
    //When self.clickedRow = -1, clicked on NSTableColumn
    if(self.clickedRow<0){
        NSTableColumn *column = self.tableColumns[self.clickedColumn];
        title = column.title?[NSString stringWithFormat:@"[column:%@]",column.title]:[NSString stringWithFormat:@"[column:%ld]",self.clickedColumn];
    }else{
        NSView *itemView =  [self viewAtColumn:clickedColumn row:self.clickedRow makeIfNecessary:YES];
        if(itemView && itemView.subviews.count>0){
            for (NSView *sub in itemView.subviews) {
                if([sub isKindOfClass:NSTextField.class]){
                    NSTextField *lable = (NSTextField *)sub;
                    title = lable.stringValue;
                }
            }
        }
    }
    return title?[NSString stringWithFormat:@"[%@]%@",NSStringFromClass(self.class),title]:[NSString stringWithFormat:@"[%@][column:%ld][row:%ld]",NSStringFromClass(self.class),self.clickedColumn,(long)self.clickedRow];
}
@end

#endif
