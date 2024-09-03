//
//  LJCChatLayout.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatLayout.h"
#import "LJCChatHelper.h"

@implementation LJCChatLayout

- (instancetype)initWithChat:(LJCChatModel *)chat
{
    if (self = [super init]) {
        _chat = chat;
        
        _marginTop = kChatTimeMargin;
        _timeHeight = 22.f;
        _bubbleMarginTop = kChatTimeMargin;
        _videoDurationHeight = kChatVideoDurationHeight;
        _marginBottom = 10.f;
        
        [self layout];
    }
    return self;
}

- (void)layout
{
    [self p_layout];
    
    _height = 0.f;
    _height += _marginTop;
    _height += _timeHeight;
    _height += _bubbleMarginTop;
    _height += _bubbleHeight;
    _height += _marginBottom;
}

#pragma mark - Layout
- (void)p_layout
{
    [self p_layoutTime];
    
    if (_chat.chatType == LJCChatSourceTypeText) {
        [self p_layoutTextMessage];
    }
    else if (_chat.chatType == LJCChatSourceTypePhoto) {
        [self p_layoutPhotoMessage];
    }
    else if (_chat.chatType == LJCChatSourceTypeVoice) {
        [self p_layoutVoiceMessage];
    }
    else if (_chat.chatType == LJCChatSourceTypeVideo) {
        [self p_layoutVideoMessage];
    }
}

- (void)p_layoutTime
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", [LJCChatHelper stringWithTimelineDate:_chat.createTime]]];
    text.color = [UIColor whiteColor];
    text.font = [UIFont systemFontOfSize:13];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(MAXFLOAT, _timeHeight)];
    _timeTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    _timeWidth = _timeTextLayout.textBoundingSize.width;
}

- (void)p_layoutTextMessage
{
    NSAttributedString *text = [self p_textWithChatMessage:_chat.content];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kChatTextMaxWidth, MAXFLOAT)];
    _bubbleTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    _bubbleTextHeight = _bubbleTextLayout.textBoundingSize.height;
    _bubbleTextWidth = _bubbleTextLayout.textBoundingSize.width;
    
    _bubbleHeight = _bubbleTextHeight + 2*kChatTextMarginY;
    _bubbleWidth = _bubbleTextWidth + 2*kChatTextMarginX + kChatBubbleMargin;
    _bubbleHeight = CGFloatPixelRound(_bubbleHeight);
    _bubbleWidth = CGFloatPixelRound(_bubbleWidth);
}

- (void)p_layoutPhotoMessage
{
    CGFloat height = _chat.photoHeight;
    CGFloat width = _chat.photoWidth;
    if (height > 0 && width > 0) {
        if (height > width) {
            width = width / height * kChatPhotoMaxLength;
            height = kChatPhotoMaxLength;
        }
        else {
            height = height / width * kChatPhotoMaxLength;
            width = kChatPhotoMaxLength;
        }
    }
    
    _bubbleHeight = round(height);
    _bubbleWidth = round(width);
}

- (void)p_layoutVideoMessage
{
    [self p_layoutPhotoMessage];
    
    if (!_chat.duration) {
        _videoDurationHeight = 0.f;
        _videoDurationWidth = 0.f;
        _videoDurationTextLayout = nil;
        return;
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_chat.duration];
    text.color = [UIColor whiteColor];
    text.font = [UIFont systemFontOfSize:10];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(MAXFLOAT, _videoDurationHeight)];
    _videoDurationTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    _videoDurationWidth = _videoDurationTextLayout.textBoundingSize.width;
}

- (void)p_layoutVoiceMessage
{
    
}

#pragma mark -
- (NSAttributedString *)p_textWithChatMessage:(NSString *)message
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:message ?: @""];
    text.color = [UIColor blackColor];
    text.font = [UIFont systemFontOfSize:15];
    
    // 高亮状态的背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = UIColorHex(bfdffe);
    
    [self p_replaceHighlightMessage:text highlightBorder:highlightBorder withRegularExpression:[LJCChatHelper regexURL]];
    [self p_replaceHighlightMessage:text highlightBorder:highlightBorder withRegularExpression:[LJCChatHelper regexEmail]];
    [self p_replaceEmotionMessage:text];
    
    return text;
}

- (void)p_replaceHighlightMessage:(NSMutableAttributedString *)text highlightBorder:(YYTextBorder *)highlightBorder withRegularExpression:(NSRegularExpression *)regex
{
    BOOL isEmail = [regex isEqual:[LJCChatHelper regexEmail]];
    NSArray<NSTextCheckingResult *> *chatURLs = [regex matchesInString:text.string options:0 range:NSMakeRange(0, text.string.length)];
    
    for (NSTextCheckingResult *match in chatURLs) {
        
        // 替换的超链接文本
        NSMutableAttributedString *replace = [[NSMutableAttributedString alloc] initWithString:[text.string substringWithRange:match.range]];
        replace.font = text.font;
        replace.color = isEmail ? [UIColor colorWithRed:0.000 green:0.519 blue:1.000 alpha:1.000] : UIColorHex(527ead);
        
        // 高亮状态
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setBackgroundBorder:highlightBorder];
        // 数据信息，用于稍后用户点击
        highlight.userInfo = @{ (isEmail ? @"chatEmail" : @"chatURL") : replace.string };
        [replace setTextHighlight:highlight range:NSMakeRange(0, replace.length)];
        
        // 替换
        [text replaceCharactersInRange:match.range withAttributedString:replace];
    }
}

- (void)p_replaceEmotionMessage:(NSMutableAttributedString *)text
{
    NSArray<NSTextCheckingResult *> *emoticons = [[LJCChatHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    
    // 逆序，[笑哭] -> 😂，location 减少3
    for (NSTextCheckingResult *emoticon in [emoticons reverseObjectEnumerator]) {
        if (emoticon.range.location == NSNotFound && emoticon.range.length <= 1) {
            continue;
        }
        
        NSRange range = emoticon.range;
        if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) {
            continue;
        }
        NSString *emoString = [text.string substringWithRange:range];
        NSString *imagePath = [LJCChatHelper emoticonPaths][emoString];
        UIImage *image = [LJCChatHelper imageWithPath:imagePath];
        if (!image) continue;
        
        ///< 绑定文本
        __block BOOL containsBindingRange = NO;
        [text enumerateAttribute:YYTextBindingAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
            if (value) {
                containsBindingRange = YES;
                *stop = YES;
            }
        }];
        if (containsBindingRange) continue;
        
        ///< 替换自定义表情，eg. [笑哭] -> 😂
        YYTextBackedString *backed = [YYTextBackedString stringWithString:emoString];
        NSMutableAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:text.font.pointSize + 2.f].mutableCopy;
        // original text, used for text copy
        [emoText setTextBackedString:backed range:NSMakeRange(0, emoText.length)];
        [emoText setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:NSMakeRange(0, emoText.length)];
        
        [text replaceCharactersInRange:range withAttributedString:emoText];
    }
}
@end
