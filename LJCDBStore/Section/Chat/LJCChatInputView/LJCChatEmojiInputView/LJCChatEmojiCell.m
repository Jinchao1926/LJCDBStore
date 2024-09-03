//
//  LJCChatEmojiCell.m
//  LJCDBStore
//
//  Created by 林锦超 on 30/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatEmojiCell.h"
#import "LJCChatEmotion.h"
#import "LJCChatHelper.h"

@interface LJCChatEmojiCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong, readwrite) LJCChatEmotion *emotion;
@end

@implementation LJCChatEmojiCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.center = CGPointMake(self.width / 2, self.height / 2);
}

#pragma mark - Getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.size = CGSizeMake(32, 32);
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

#pragma mark - Setter
- (void)setBackspace:(BOOL)backspace
{
    _backspace = backspace;
    
    self.imageView.image = backspace ? [UIImage imageNamed:@"compose_emotion_delete"] : nil;
}

- (void)configWithEmotion:(LJCChatEmotion *)emotion
{
    if (!emotion) {
        [self.imageView cancelCurrentImageRequest];
        self.imageView.image = nil;
        return;
    }
    _emotion = emotion;
    
    if (emotion.type == LJCEmoticonTypeEmoji) {
        ///< emoji
        NSNumber *code = [NSNumber numberWithString:emotion.code];
        NSString *codeString = [NSString stringWithUTF32Char:code.unsignedIntValue];
        if (codeString) {
            self.imageView.image = [UIImage imageWithEmoji:codeString size:self.imageView.width];
        }
    }
    else if (emotion.group.groupID && emotion.png) {
        ///< 自定义表情
        NSString *pngPath = [[LJCChatHelper emoticonBundle] pathForScaledResource:emotion.png ofType:nil inDirectory:emotion.group.groupID];
        if (!pngPath) {
            ///< 尝试查找 additonal 目录
            NSString *addBundlePath = [[LJCChatHelper emoticonBundle].bundlePath stringByAppendingPathComponent:@"additional"];
            NSBundle *addBundle = [NSBundle bundleWithPath:addBundlePath];
            pngPath = [addBundle pathForScaledResource:emotion.png ofType:nil inDirectory:emotion.group.groupID];
        }
        if (pngPath) {
            [self.imageView setImageWithURL:[NSURL fileURLWithPath:pngPath] options:YYWebImageOptionIgnoreDiskCache];
        }
    }
}
@end
