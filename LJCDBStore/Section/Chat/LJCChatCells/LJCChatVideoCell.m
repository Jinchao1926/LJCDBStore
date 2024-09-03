//
//  LJCChatVideoCell.m
//  LJCDBStore
//
//  Created by 林锦超 on 08/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatVideoCell.h"

@interface LJCChatVideoCell()
@property (nonatomic, strong) UIImageView *playView;
@property (nonatomic, strong) YYLabel *durationLabel;
@end
@implementation LJCChatVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.playView];
        [self addSubview:self.durationLabel];
    }
    return self;
}

- (UIImageView *)playView
{
    if (!_playView) {
        _playView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"videoPlay"]];
    }
    return _playView;
}

- (YYLabel *)durationLabel
{
    if (!_durationLabel) {
        _durationLabel = [YYLabel new];
        _durationLabel.displaysAsynchronously = YES;
        _durationLabel.ignoreCommonProperties = YES;
        _durationLabel.fadeOnAsynchronouslyDisplay = NO;
        _durationLabel.fadeOnHighlight = NO;
        _durationLabel.lineBreakMode = NSLineBreakByClipping;
        _durationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _durationLabel;
}

#pragma mark - Layout
- (void)configWithLayout:(LJCChatLayout *)layout
{
    [super configWithLayout:layout];
    
    /// video thumbnail
    self.chatImageView.contentImage = (UIImage *)[[YYCache chatImageCache] objectForKey:layout.chat.thumbFileURL.absoluteString];
    
    /// play video
    self.playView.size = CGSizeMake(kChatVideoPlayLength, kChatVideoPlayLength);
    self.playView.center = CGPointMake(CGRectGetMidX(self.chatImageView.frame), CGRectGetMidY(self.chatImageView.frame));
    
    /// duration
    BOOL isMessageFromSelf = layout.chat.isFromSelf;
    self.durationLabel.size = CGSizeMake(layout.videoDurationWidth, layout.videoDurationHeight);
    self.durationLabel.bottom = CGRectGetMaxY(self.chatImageView.frame);
    self.durationLabel.right = CGRectGetMaxX(self.chatImageView.frame) - kChatVideoDurationMargin - (isMessageFromSelf ? kChatBubbleMargin : 0.f);
    self.durationLabel.textLayout = layout.videoDurationTextLayout;
}

@end
