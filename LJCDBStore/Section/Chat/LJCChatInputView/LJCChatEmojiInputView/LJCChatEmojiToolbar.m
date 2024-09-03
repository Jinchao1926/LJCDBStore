//
//  LJCChatEmojiToolbar.m
//  LJCDBStore
//
//  Created by 林锦超 on 01/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatEmojiToolbar.h"

#define kToolbarSendButtonWidth 70

@interface LJCChatEmojiToolbar()
@property (nonatomic, strong) UIScrollView *toolbar;
@property (nonatomic, strong) UIImageView *toolbarBg;
@property (nonatomic, strong) NSMutableArray<UIButton *> *toolbarButtons;
@property (nonatomic, strong) UIButton *sendEmojiButton;

@property (nonatomic, strong) NSArray *names;
@end
@implementation LJCChatEmojiToolbar

- (instancetype)initWithFrame:(CGRect)frame names:(NSArray *)names
{
    if (self = [super initWithFrame:frame]) {
        _names = names;
        _toolbarButtons = [NSMutableArray new];
        
        [self addSubview:self.toolbar];
        [self addSubview:self.sendEmojiButton];
        [self p_layoutSubViews];
        
        self.sendEnable = NO;
    }
    return self;
}

- (void)p_layoutSubViews
{
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.and.bottom.equalTo(self);
        make.right.equalTo(self.sendEmojiButton.mas_left);
    }];
    
    [self.sendEmojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.and.right.equalTo(self);
        make.width.mas_equalTo(kToolbarSendButtonWidth);
    }];
    
    /// toolbar bg
    [self.toolbarBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.toolbar);
    }];
    
    /// toolbar buttons
    NSInteger count = MIN(self.names.count, 3); //toolbar最多同时显示3个按钮
    CGFloat oneWidth = (kScreenWidth - kToolbarSendButtonWidth) / count;
    [self.toolbarButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull button, NSUInteger idx, BOOL * _Nonnull stop) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.toolbar);
            make.width.mas_equalTo(oneWidth);
            make.left.equalTo(self.toolbar).offset(oneWidth * idx);
        }];
    }];
}

#pragma mark - Getter
- (UIScrollView *)toolbar
{
    if (!_toolbar) {
        _toolbar = [UIScrollView new];
        _toolbar.backgroundColor = [UIColor lightGrayColor];
        _toolbar.showsHorizontalScrollIndicator = NO;
        _toolbar.alwaysBounceHorizontal = YES;
        
        _toolbarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"compose_emotion_table_right_normal"]];
        [_toolbar addSubview:_toolbarBg];
        
        [self.names enumerateObjectsUsingBlock:^(NSString * _Nonnull name, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [self p_createToolbarButton:name];
            [self.toolbarButtons addObject:button];
            [_toolbar addSubview:button];
        }];
    }
    return _toolbar;
}

- (UIButton *)sendEmojiButton
{
    if (!_sendEmojiButton) {
        _sendEmojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendEmojiButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_sendEmojiButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendEmojiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendEmojiButton setBackgroundColor:[UIColor colorWithRed:0.000 green:0.519 blue:1.000 alpha:1.000]];
        [_sendEmojiButton addTarget:self action:@selector(handleSendEmojiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendEmojiButton;
}

- (UIButton *)p_createToolbarButton:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:UIColorHex(5D5C5A) forState:UIControlStateSelected];
    [button setTitle:title forState:UIControlStateNormal];
    
    UIImage *image = [UIImage imageNamed:@"compose_emotion_table_left_normal"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    image = [UIImage imageNamed:@"compose_emotion_table_left_selected"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, image.size.width - 1) resizingMode:UIImageResizingModeStretch];
    [button setBackgroundImage:image forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(handleToolbarButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - Action
- (IBAction)handleToolbarButtonPressed:(id)sender
{
    NSInteger index = [self.toolbarButtons indexOfObject:sender];
    if (self.switchEmojiGroupBlock) {
        self.switchEmojiGroupBlock(index);
    }
}

- (IBAction)handleSendEmojiButtonPressed:(id)sender
{
    if (self.sendEmojiBlock) {
        self.sendEmojiBlock();
    }
}

#pragma mark - Public
- (void)setSendEnable:(BOOL)sendEnable
{
    _sendEnable = sendEnable;
    
    self.sendEmojiButton.userInteractionEnabled = sendEnable;
    [self.sendEmojiButton setTitleColor:(sendEnable ? [UIColor whiteColor] : [UIColor lightGrayColor]) forState:UIControlStateNormal];
    self.sendEmojiButton.backgroundColor = sendEnable ? [UIColor colorWithRed:0.000 green:0.519 blue:1.000 alpha:1.000] :UIColorHex(f0f0f0);
}

- (void)setToolbarButtonSelectedAtIndex:(NSInteger)groupIndex
{
    // toolbar 选中
    [self.toolbarButtons enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = (groupIndex == idx);
    }];
}

@end
