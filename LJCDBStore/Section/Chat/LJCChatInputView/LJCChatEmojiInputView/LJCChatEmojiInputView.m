//
//  LJCChatEmojiInputView.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatEmojiInputView.h"
#import "LJCChatEmojiToolbar.h"
#import "LJCChatEmojiCollectionView.h"
#import "LJCChatEmojiCell.h"
#import "LJCChatRequestManager.h"
#import "LJCChatEmotion.h"


#define kEmojiInputHeight   (216 + kUnsafeBottomHeight)
#define kEmojiPageControlHeight 20
#define kEmojiToolbarHeight 37

#define kOneEmoticonHeight  50
#define kOnePageCount       20

#define kEmojiCountPerRow   7.0
#define kEmojiCountPerCol   3

@interface LJCChatEmojiInputView() <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UIInputViewAudioFeedback>
@property (nonatomic, strong) LJCChatEmojiCollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) LJCChatEmojiToolbar *toolbar;

@property (nonatomic, strong) LJCChatRequestManager *requestManager;
@property (nonatomic, strong) NSArray<LJCChatEmotionGroup *> *emotionGroups;
@property (nonatomic, strong) NSArray<NSNumber *> *emotionGroupPageIndexs;  //每组表情包的起始索引
@property (nonatomic, strong) NSArray<NSNumber *> *emotionGroupPageCounts;  //每组表情包的页数，每页 kOnePageCount 个
@property (nonatomic, assign) NSUInteger emoticonGroupTotalPageCount;       //总的表情包页数
@property (nonatomic, assign) NSUInteger currentEmotionPageIndex;           //当前表情包页码
@end
@implementation LJCChatEmojiInputView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)willDealloc
{
    return NO;
}

+ (void)load
{
    NSLog(@"LJCChatEmojiInputView +load.");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LJCChatEmojiInputView sharedInputView];
    });
}

+ (instancetype)sharedInputView
{
    static LJCChatEmojiInputView *emoji = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emoji = [[[self class] alloc] _init];
    });
    return emoji;
}

- (instancetype)_init
{
    if (self = [super init]) {
        
        _requestManager = [LJCChatRequestManager new];
        _currentEmotionPageIndex = NSNotFound;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self p_initEmojiGroups];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.size = CGSizeMake(kScreenWidth, kEmojiInputHeight);
                self.backgroundColor = UIColorHex(f9f9f9);
                [self addSubview:self.collectionView];
                [self addSubview:self.pageControl];
                [self addSubview:self.toolbar];
                [self p_layoutSubViews];
                
                [self p_switchEmojiGroupAtIndex:0];
            });
        });
    }
    return self;
}

- (void)p_layoutSubViews
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.top.equalTo(self).offset(5);
        make.height.mas_equalTo(kOneEmoticonHeight * 3);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(5);
        make.left.and.right.equalTo(self.collectionView);
        make.height.mas_equalTo(kEmojiPageControlHeight);
    }];
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self).offset(-kUnsafeBottomHeight);
        make.height.mas_equalTo(kEmojiToolbarHeight);
    }];
}

#pragma mark -
- (void)p_initEmojiGroups
{
    // 所有表情是放在左右移动的 collectionView
    // _emoticonGroupPageIndexs，表示每个分组表情的起始页码， eg.[0, 6, 10]
    // _emoticonGroupPageCounts，表示每个分组的的表情页数，eg.[6, 4, 2]
    // _pageControl 每移动一页，页码 +/- 1
    // _toolBar 点击，可以根据分组快速切换页码到 _emoticonGroupPageIndexs[groupNum]
    _emotionGroups = [self.requestManager fetchEmoticonGroups];
//    NSLog(@"_emotionGroups:%@", _emotionGroups);
    
    __block NSUInteger index = 0;
    NSMutableArray *indexs = [NSMutableArray array];
    NSMutableArray *pageCounts = [NSMutableArray new];
    [_emotionGroups enumerateObjectsUsingBlock:^(LJCChatEmotionGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        [indexs addObject:@(index)];
        
        NSUInteger pageCount = ceil(obj.emoticons.count / kOnePageCount);  //小数向上取整
        if (0 == pageCount) {
            pageCount = 1;
        }
        index += pageCount;
        
        [pageCounts addObject:@(pageCount)];
    }];
    _emotionGroupPageIndexs = [indexs copy];
    _emotionGroupPageCounts = [pageCounts copy];
    _emoticonGroupTotalPageCount = index;
}

- (LJCChatEmotion *)p_emotionWithIndexPath:(NSIndexPath *)indexPath
{
    __block LJCChatEmotion *emotion = nil;
    NSInteger section = indexPath.section;
    
    [self.emotionGroupPageIndexs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSNumber * _Nonnull pageIndex, NSUInteger idx, BOOL * _Nonnull stop) {
        /// 逆序找到对应的表情分组
        if (section >= pageIndex.unsignedIntegerValue) {
            LJCChatEmotionGroup *group = self.emotionGroups[idx];
            NSUInteger pageInGroup = section - pageIndex.unsignedIntegerValue;
            
            // 多行，水平滚动的集合视图
            // 0 3 6 9  12 15 18 ...
            // 1 4 7 10 13 16 19 ...
            // 2 5 8 11 14 17 20 ...
            // transpose line/row
            NSUInteger reRow = (indexPath.row % kEmojiCountPerCol) * kEmojiCountPerRow + indexPath.row / kEmojiCountPerCol;
            NSUInteger indexInGroup = pageInGroup * kOnePageCount + reRow;
            
//            NSLog(@"[%zd-%zd] reRow:%zd indexInGroup:%zd group.emoticons.count:%zd", section, indexPath.row, reRow, indexInGroup, group.emoticons.count);
            if (indexInGroup < group.emoticons.count) {
                emotion = group.emoticons[indexInGroup];
            }
            *stop = YES;
        }
    }];
    
    return emotion;
}

- (void)p_switchEmojiGroupAtIndex:(NSInteger)index
{
    if (index < self.emotionGroupPageIndexs.count) {
        NSInteger pageIndex = self.emotionGroupPageIndexs[index].unsignedIntegerValue;
        CGRect rect = CGRectMake(self.collectionView.width * pageIndex, 0, self.collectionView.width, self.collectionView.height);
        [self.collectionView scrollRectToVisible:rect animated:NO];
        [self scrollViewDidScroll:self.collectionView];
    }
}

#pragma mark - Getter
- (LJCChatEmojiCollectionView *)collectionView
{
    if (!_collectionView) {
        CGFloat itemWidth = (kScreenWidth - 10 * 2) / kEmojiCountPerRow;
        itemWidth = CGFloatPixelRound(itemWidth);
        CGFloat padding = (kScreenWidth - kEmojiCountPerRow * itemWidth) / 2.0;
        CGFloat paddingLeft = CGFloatPixelRound(padding);
        CGFloat paddingRight = kScreenWidth - paddingLeft - itemWidth * kEmojiCountPerRow;
        
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(itemWidth, kOneEmoticonHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, paddingLeft, 0, paddingRight);
        
        _collectionView = [[LJCChatEmojiCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kOneEmoticonHeight * 3) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[LJCChatEmojiCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView reloadData];
//        for (NSInteger row = 0; row < kOnePageCount + 1; row++) {
//            LJCChatEmojiCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
//            NSLog(@"[%zd]cell:%p", row, cell);
//        }
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [UIPageControl new];
        _pageControl.pageIndicatorTintColor = UIColorHex(dedede);
        _pageControl.currentPageIndicatorTintColor = UIColorHex(fd8225);
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}

- (LJCChatEmojiToolbar *)toolbar
{
    if (!_toolbar) {
        __block NSMutableArray *nameCNs = [NSMutableArray array];
        [self.emotionGroups enumerateObjectsUsingBlock:^(LJCChatEmotionGroup * _Nonnull group, NSUInteger idx, BOOL * _Nonnull stop) {
            [nameCNs addObject:group.nameCN];
        }];
        _toolbar = [[LJCChatEmojiToolbar alloc] initWithFrame:CGRectZero names:nameCNs];
        @weakify(self)
        _toolbar.switchEmojiGroupBlock = ^(NSInteger groupIndex) {
            @strongify(self)
            [self p_switchEmojiGroupAtIndex:groupIndex];
        };
        _toolbar.sendEmojiBlock = ^{
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(LJCChatEmojiInputViewDidSendEmoji)]) {
                [self.delegate LJCChatEmojiInputViewDidSendEmoji];
            }
        };
    }
    return _toolbar;
}

#pragma mark - Setter
- (void)setFirstResponder:(id<UITextInput>)firstResponder
{
    _firstResponder = firstResponder;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldTextDidChanged:(NSNotification *)notification
{
    self.toolbar.sendEnable = _firstResponder.hasText;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取页码
    NSInteger pageIndex = round(scrollView.contentOffset.x / scrollView.width);
    if (pageIndex < 0) {
        pageIndex = 0;
    }
    else if (pageIndex >= self.emoticonGroupTotalPageCount) {
        pageIndex = self.emoticonGroupTotalPageCount - 1;
    }
    
    if (pageIndex == self.currentEmotionPageIndex) {
        return;
    }
    self.currentEmotionPageIndex = pageIndex;
    
    // 获取分组
    __block NSInteger groupIndex = 0;
    [self.emotionGroupPageIndexs enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (pageIndex >= obj.unsignedIntegerValue) {
            groupIndex = idx;
            
            *stop = YES;
        }
    }];
    
    NSInteger groupPageIndex = self.emotionGroupPageIndexs[groupIndex].unsignedIntegerValue;
    NSInteger groupPageCount = self.emotionGroupPageCounts[groupIndex].unsignedIntegerValue;
    
    // pageControl
    self.pageControl.numberOfPages = groupPageCount;
    self.pageControl.currentPage = pageIndex - groupPageIndex;
    //    NSLog(@"pageIndex:%zd groupPageIndex:%zd", pageIndex, groupPageIndex);
    
    // toolbar 选中
    [self.toolbar setToolbarButtonSelectedAtIndex:groupIndex];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.emoticonGroupTotalPageCount;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kOnePageCount + 1;   //多出一个 backspace 按钮
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LJCChatEmojiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row == kOnePageCount) {
        cell.backspace = YES;
    }
    else {
        cell.backspace = NO;
        [cell configWithEmotion:[self p_emotionWithIndexPath:indexPath]];
    }
//    NSLog(@"cellForItemAtIndexPath[%zd] %p", indexPath.row, cell);
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LJCChatEmojiCell *cell = (LJCChatEmojiCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.isBackspace) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(LJCChatEmojiInputViewDidTapBackspace)]) {
            [[UIDevice currentDevice] playInputClick];  //声音
            [self.delegate LJCChatEmojiInputViewDidTapBackspace];
        }
    }
    else if (cell.emotion) {
        NSString *emojiText = nil;
        if (cell.emotion.type == LJCEmoticonTypeImage) {
            emojiText = cell.emotion.chs;
        }
        else {
            ///< LJCEmoticonTypeEmoji
            NSNumber *code = [NSNumber numberWithString:cell.emotion.code];
            emojiText = [NSString stringWithUTF32Char:code.unsignedIntValue];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(LJCChatEmojiInputViewDidInputText:)]) {
            [[UIDevice currentDevice] playInputClick];  //声音
            [self.delegate LJCChatEmojiInputViewDidInputText:emojiText];
        }
    }
}

#pragma mark - UIInputViewAudioFeedback
- (BOOL)enableInputClicksWhenVisible
{
    // enable [[UIDevice currentDevice] playInputClick];
    return NO;
}

@end
