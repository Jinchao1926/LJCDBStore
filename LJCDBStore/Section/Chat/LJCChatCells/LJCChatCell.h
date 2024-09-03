//
//  LJCChatCell.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJCChatLayout.h"

@class LJCChatCell;
@protocol LJCChatCellDelegate <NSObject>
///< 点击了 Label 的链接
- (void)cell:(LJCChatCell *)cell didClickInLabel:(YYLabel *)label textRange:(NSRange)textRange;
@end

@interface LJCChatCell : UITableViewCell

@property (nonatomic, strong, readonly) YYLabel *timeLabel;
@property (nonatomic, strong, readonly) UIButton *avatarView;
@property (nonatomic, strong, readonly) UIImageView *bubbleView;

@property (nonatomic, weak) id<LJCChatCellDelegate> delegate;
@property (nonatomic, strong, readonly) LJCChatLayout *layout;

- (void)configWithLayout:(LJCChatLayout *)layout;

- (UIImage *)bubbleImageWithMessageFrom:(BOOL)isOwnMessage;
@end
