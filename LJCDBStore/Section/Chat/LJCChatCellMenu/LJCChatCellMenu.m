//
//  LJCChatCellMenu.m
//  LJCDBStore
//
//  Created by 林锦超 on 15/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatCellMenu.h"

@interface LJCChatCellMenu()
@property (nonatomic, assign, getter=isMenuShowing, readwrite) BOOL menuShowing;
@property (nonatomic, strong) UIMenuController *menuController;
@end
@implementation LJCChatCellMenu

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)sharedMenu
{
    static LJCChatCellMenu *menu = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menu = [[[self class] alloc] _init];
    });
    return menu;
}

- (instancetype)_init
{
    if (self = [super init]) {
        _menuShowing = NO;
        _menuController = [UIMenuController sharedMenuController];
        [self addMenuItems];
        
        self.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGR];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHideMenu:) name:UIMenuControllerWillHideMenuNotification object:self.menuController];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder
{
    // Note：设置第一响应者，才能显示UIMenuController
    // 失去第一响应者时，UIMenuController会自动消失
    return YES;
}

#pragma mark - Notification
- (void)menuControllerWillHideMenu:(NSNotification *)notification
{
    if (![notification.object isEqual:self.menuController]) {
        return;
    }

    [self removeFromSuperview];
    
    _menuShowing = NO;
}

#pragma mark - Private
- (void)addMenuItems
{
    UIMenuItem *cancelItem = [[UIMenuItem alloc] initWithTitle:@"取消" action:@selector(dismiss)];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopyMenuItemPressed)];
    UIMenuItem *likeItem = [[UIMenuItem alloc] initWithTitle:@"收藏" action:@selector(dismiss)];
    UIMenuItem *retweetItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(dismiss)];
    UIMenuItem *remindItem = [[UIMenuItem alloc] initWithTitle:@"提醒" action:@selector(dismiss)];
    UIMenuItem *openItem = [[UIMenuItem alloc] initWithTitle:@"打开" action:@selector(dismiss)];
    UIMenuItem *translateItem = [[UIMenuItem alloc] initWithTitle:@"翻译" action:@selector(dismiss)];
    self.menuController.menuItems = @[ cancelItem, copyItem, likeItem, retweetItem, remindItem, openItem, translateItem ];
}

- (void)dismiss
{
    [self handleMenuItemPressed:LJCChatCellMenuTypeCancel];
}

- (void)handleCopyMenuItemPressed
{
    [self handleMenuItemPressed:LJCChatCellMenuTypeCopy];
}

- (void)handleMenuItemPressed:(LJCChatCellMenuType)menuType
{
    // hide MenuController
    [self.menuController setMenuVisible:NO animated:YES];
    
    if (self.tappedHandler) {
        self.tappedHandler(menuType);
    }
}

#pragma mark - Public
- (void)showMenuInView:(UIView *)view targetRect:(CGRect)rect completion:(LJCChatCellMenuDidTappedHandler)handler
{
    if (self.isMenuShowing) {
        return;
    }
    _menuShowing = YES;
    
    self.tappedHandler = handler;
    self.frame = view.bounds;
    [view addSubview:self];
    
    [self becomeFirstResponder];
    [self.menuController setTargetRect:rect inView:self];
    [self.menuController setMenuVisible:YES animated:YES];
}

@end
