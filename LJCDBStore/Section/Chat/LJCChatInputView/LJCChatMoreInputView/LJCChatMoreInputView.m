//
//  LJCChatMoreInputView.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatMoreInputView.h"
#import "LJCChatMoreCell.h"

#define kMoreCollectionHeight   216
#define kMoreInputHeight (kMoreCollectionHeight + kUnsafeBottomHeight)

#define kMoreCountPerRow    4.f
#define kMoreCountPerCol    2.f

@interface LJCChatMoreInputView() <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation LJCChatMoreInputView

- (BOOL)willDealloc
{
    return NO;
}

+ (instancetype)sharedInputView
{
    static LJCChatMoreInputView *more = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        more = [[[self class] alloc] _init];
    });
    return more;
}

- (instancetype)_init
{
    if (self = [super init]) {
        self.size = CGSizeMake(kScreenWidth, kMoreInputHeight);
        self.backgroundColor = UIColorHex(f9f9f9);
        [self addSubview:self.collectionView];
        
        [self p_layoutSubViews];
    }
    return self;
}

- (void)p_layoutSubViews
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.equalTo(self);
        make.height.mas_equalTo(kMoreCollectionHeight);
    }];
}

#pragma mark - Getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat itemWidth = (kScreenWidth - 10 * 2) / kMoreCountPerRow;
        itemWidth = CGFloatPixelFloor(itemWidth);
        CGFloat padding = (kScreenWidth - kMoreCountPerRow * itemWidth) / 2.0;
        CGFloat paddingLeft = CGFloatPixelRound(padding);
        CGFloat paddingRight = kScreenWidth - paddingLeft - itemWidth * kMoreCountPerRow;
        
        CGFloat itemHeight = (kMoreCollectionHeight - 10 * 2) / kMoreCountPerCol;
        itemHeight = CGFloatPixelRound(itemHeight);
        CGFloat paddingTop = (kMoreCollectionHeight - kMoreCountPerCol * itemHeight) / 2.0;
        paddingTop = CGFloatPixelRound(paddingTop);
        CGFloat paddingBottom = kMoreCollectionHeight - paddingTop - itemHeight * kMoreCountPerCol;
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(paddingTop, paddingLeft, 0, paddingBottom);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, kMoreCollectionHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorHex(f9f9f9);
        [_collectionView registerClass:[LJCChatMoreCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LJCChatMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell configWithType:(LJCChatMoreCellType)indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LJCChatMoreCell *cell = (LJCChatMoreCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.delegate && [self.delegate respondsToSelector:@selector(LJCChatMoreInputViewDidSelected:)]) {
        [self.delegate LJCChatMoreInputViewDidSelected:cell.moreType];
    }
}
@end
