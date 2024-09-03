//
//  LJCChatCellMenu.h
//  LJCDBStore
//
//  Created by 林锦超 on 15/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LJCChatCellMenuType)
{
    LJCChatCellMenuTypeCancel,
    LJCChatCellMenuTypeCopy,
};
typedef void(^LJCChatCellMenuDidTappedHandler)(LJCChatCellMenuType menuType);
@interface LJCChatCellMenu : UIView

/// 是否显示Menu
@property (nonatomic, assign, getter=isMenuShowing, readonly) BOOL menuShowing;
/// block
@property (nonatomic, copy) LJCChatCellMenuDidTappedHandler tappedHandler;

+ (instancetype)sharedMenu;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

- (void)showMenuInView:(UIView *)view targetRect:(CGRect)rect completion:(LJCChatCellMenuDidTappedHandler)handler;
@end
