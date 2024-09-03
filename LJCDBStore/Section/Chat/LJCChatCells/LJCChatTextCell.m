//
//  LJCChatTextCell.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatTextCell.h"
#import "LJCChatCellMenu.h"

@interface LJCChatTextCell()
@property (nonatomic, strong) YYLabel *chatTextLabel;
@end
@implementation LJCChatTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.chatTextLabel];
        
        // Note: long press
        self.bubbleView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesturePressed:)];
        [self.bubbleView addGestureRecognizer:longPressGR];
    }
    return self;
}

- (YYLabel *)chatTextLabel
{
    if (!_chatTextLabel) {
        _chatTextLabel = [YYLabel new];
        _chatTextLabel.displaysAsynchronously = YES;
        _chatTextLabel.ignoreCommonProperties = YES;
        _chatTextLabel.fadeOnAsynchronouslyDisplay = NO;
        _chatTextLabel.fadeOnHighlight = NO;
        _chatTextLabel.lineBreakMode = NSLineBreakByClipping;
        _chatTextLabel.numberOfLines = 0;
        
        @weakify(self)
        _chatTextLabel.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self)
            if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
                [self.delegate cell:self didClickInLabel:self.chatTextLabel textRange:range];
            }
        };
    }
    return _chatTextLabel;
}

#pragma mark - Layout
- (void)configWithLayout:(LJCChatLayout *)layout
{
    [super configWithLayout:layout];
    
    BOOL isMessageFromSelf = layout.chat.isFromSelf;
    
    /// bubble
    self.bubbleView.size = CGSizeMake(layout.bubbleWidth, layout.bubbleHeight);
    self.bubbleView.left = isMessageFromSelf ? self.avatarView.left - kChatBubbleMargin - self.bubbleView.width : self.avatarView.right + kChatBubbleMargin;
    self.bubbleView.image = [self bubbleImageWithMessageFrom:isMessageFromSelf];
    self.bubbleView.hidden = NO;
    
    /// text
    self.chatTextLabel.top = self.bubbleView.top + kChatTextMarginY;
    self.chatTextLabel.size = CGSizeMake(layout.bubbleTextWidth, layout.bubbleTextHeight);
    self.chatTextLabel.left = self.bubbleView.left + kChatTextMarginX;
    self.chatTextLabel.textLayout = layout.bubbleTextLayout;
}

#pragma mark - Action
- (IBAction)handleLongGesturePressed:(id)sender
{
    [[LJCChatCellMenu sharedMenu] showMenuInView:self targetRect:self.bubbleView.frame completion:^(LJCChatCellMenuType menuType) {
        if (menuType == LJCChatCellMenuTypeCopy) {
            /// 剪切板
            [[UIPasteboard generalPasteboard] setString:self.layout.chat.content];
        }
    }];
}
@end
