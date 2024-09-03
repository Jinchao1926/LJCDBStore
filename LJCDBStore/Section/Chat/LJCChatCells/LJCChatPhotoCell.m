//
//  LJCChatPhotoCell.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatPhotoCell.h"
#import "LJCChatPhotoBrowserProxy.h"

@interface LJCChatPhotoCell()
@property (nonatomic, strong, readwrite) LJCShapeImageView *chatImageView;
@property (nonatomic, strong) LJCChatPhotoBrowserProxy *photoBrowserProxy;
@end
@implementation LJCChatPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.chatImageView];
    }
    return self;
}

#pragma mark - Getter
- (LJCShapeImageView *)chatImageView
{
    if (!_chatImageView) {
        _chatImageView = [LJCShapeImageView new];
        _chatImageView.backgroundColor = UIColorHex(f0f0f0);
        [_chatImageView addTarget:self action:@selector(chatImagePreview:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatImageView;
}

#pragma mark - Layout
- (void)configWithLayout:(LJCChatLayout *)layout
{
    [super configWithLayout:layout];
    
    BOOL isMessageFromSelf = layout.chat.isFromSelf;
    
    /// photo
    self.chatImageView.top = self.bubbleView.top;
    self.chatImageView.size = CGSizeMake(layout.bubbleWidth, layout.bubbleHeight);
    self.chatImageView.left = isMessageFromSelf ? self.avatarView.left - kChatBubbleMargin - self.chatImageView.width : self.avatarView.right + kChatBubbleMargin;
    self.chatImageView.maskImage = [self bubbleImageWithMessageFrom:isMessageFromSelf];
    self.chatImageView.contentImage = (UIImage *)[[YYCache chatImageCache] objectForKey:layout.chat.fileURL.absoluteString];
    
    /// bubble
    self.bubbleView.hidden = YES;
}

#pragma mark - Action
- (IBAction)chatImagePreview:(id)sender
{
    // @property 保存变量，防止 MWPhotoBrowser的delegate为nil
    _photoBrowserProxy = [[LJCChatPhotoBrowserProxy alloc] initWithChatId:@"chatId"];
    @weakify(self)
    _photoBrowserProxy.dismissHandler = ^{
        @strongify(self)
        self.photoBrowserProxy = nil;
        NSLog(@"self.photoBrowserProxy:%@", self.photoBrowserProxy);
    };
    [_photoBrowserProxy presentPhotoBrowserWithChatId:self.layout.chat.chatId];
}
@end
