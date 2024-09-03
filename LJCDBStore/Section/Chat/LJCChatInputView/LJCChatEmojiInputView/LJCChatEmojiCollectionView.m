//
//  LJCChatEmojiCollectionView.m
//  LJCDBStore
//
//  Created by 林锦超 on 30/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatEmojiCollectionView.h"

@implementation LJCChatEmojiCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundView = [UIView new];
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.clipsToBounds = NO;
        self.canCancelContentTouches = NO;
        self.multipleTouchEnabled = NO;
    }
    return self;
}
@end
