//
//  UIScrollView+LJC_YYAdd.m
//  LJCDBStore
//
//  Created by 林锦超 on 29/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "UIScrollView+LJC_YYAdd.h"
#import "UIScrollView+YYAdd.h"

@implementation UIScrollView (LJC_YYAdd)

- (void)scrollToTopIfNeeded
{
    [self scrollToTopAnimatedIfNeeded:YES];
}

- (void)scrollToBottomIfNeeded
{
    [self scrollToBottomAnimatedIfNeeded:YES];
}

- (void)scrollToLeftIfNeeded
{
    [self scrollToLeftAnimatedIfNeeded:YES];
}

- (void)scrollToRightIfNeeded
{
    [self scrollToRightAnimatedIfNeeded:YES];
}

- (void)scrollToTopAnimatedIfNeeded:(BOOL)animated
{
    if (self.contentInset.top > 0) {
        [self scrollToTopAnimated:animated];
    }
}

- (void)scrollToBottomAnimatedIfNeeded:(BOOL)animated
{
    if (self.contentSize.height - self.bounds.size.height + self.contentInset.bottom > 0.f) {
        [self scrollToBottomAnimated:animated];
    }
}

- (void)scrollToLeftAnimatedIfNeeded:(BOOL)animated
{
    if (self.contentInset.left > 0) {
        [self scrollToLeftAnimated:animated];
    }
}

- (void)scrollToRightAnimatedIfNeeded:(BOOL)animated
{
    if (self.contentSize.width - self.bounds.size.width + self.contentInset.right > 0.f) {
        [self scrollToRightAnimated:animated];
    }
}
@end
