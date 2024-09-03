//
//  LJCChatCell.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatCell.h"
#import "LJCChatLayoutConst.h"
#import "LJCChatHelper.h"

@interface LJCChatCell()
@property (nonatomic, strong, readwrite) YYLabel *timeLabel;
@property (nonatomic, strong, readwrite) UIButton *avatarView;
@property (nonatomic, strong, readwrite) UIImageView *bubbleView;

@property (nonatomic, strong, readwrite) LJCChatLayout *layout;
@end

@implementation LJCChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorHex(f0f0f0);
        
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.avatarView];
        [self.contentView addSubview:self.bubbleView];
    }
    return self;
}

- (YYLabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[YYLabel alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth, 22)];
        _timeLabel.backgroundColor = [UIColor colorWithHexString:@"cccccc"];
        _timeLabel.displaysAsynchronously = YES;
        _timeLabel.ignoreCommonProperties = YES;
        _timeLabel.fadeOnAsynchronouslyDisplay = NO;
        _timeLabel.fadeOnHighlight = NO;
        _timeLabel.lineBreakMode = NSLineBreakByClipping;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.layer.cornerRadius = 4;
    }
    return _timeLabel;
}

- (UIButton *)avatarView
{
    if (!_avatarView) {
        _avatarView = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarView.size = CGSizeMake(kChatAvatarLength, kChatAvatarLength);
    }
    return _avatarView;
}

- (UIImageView *)bubbleView
{
    if (!_bubbleView) {
        _bubbleView = [UIImageView new];
    }
    return _bubbleView;
}

#pragma mark - Public
- (UIImage *)bubbleImageWithMessageFrom:(BOOL)isOwnMessage
{
    return [LJCChatHelper bubbleImageWithMessageFrom:isOwnMessage];
}

#pragma mark - Layout
- (void)configWithLayout:(LJCChatLayout *)layout
{
    _layout = layout;
    
    self.contentView.size = CGSizeMake(kScreenWidth, layout.height);
    
    /// time
    self.timeLabel.top = layout.marginTop;
    self.timeLabel.textLayout = layout.timeTextLayout;
    self.timeLabel.size = CGSizeMake(layout.timeWidth, layout.timeHeight);
    self.timeLabel.centerX = self.contentView.centerX;
    
    BOOL isMessageFromSelf = layout.chat.isFromSelf;
    
    // avatar
    self.avatarView.top = self.timeLabel.bottom + layout.bubbleMarginTop;
    self.avatarView.left = isMessageFromSelf ? kScreenWidth - kChatAvatarMargin - kChatAvatarLength : kChatAvatarMargin;
    self.avatarView.size = CGSizeMake(kChatAvatarLength, kChatAvatarLength);
    [self.avatarView setImageWithURL:(isMessageFromSelf ? layout.chat.fromUserAvatarURL : layout.chat.toUserAvatarURL) forState:UIControlStateNormal options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation];
    
    // bubble
    self.bubbleView.top = self.avatarView.top;
}
@end
