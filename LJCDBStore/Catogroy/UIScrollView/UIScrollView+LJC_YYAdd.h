//
//  UIScrollView+LJC_YYAdd.h
//  LJCDBStore
//
//  Created by 林锦超 on 29/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (LJC_YYAdd)

- (void)scrollToTopIfNeeded;
- (void)scrollToBottomIfNeeded;
- (void)scrollToLeftIfNeeded;
- (void)scrollToRightIfNeeded;

- (void)scrollToTopAnimatedIfNeeded:(BOOL)animated;
- (void)scrollToBottomAnimatedIfNeeded:(BOOL)animated;
- (void)scrollToLeftAnimatedIfNeeded:(BOOL)animated;
- (void)scrollToRightAnimatedIfNeeded:(BOOL)animated;
@end
