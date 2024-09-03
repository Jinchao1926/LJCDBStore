//
//  LJCChatEmojiInputView.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  1.水平滚动的 collectionViewCell 位置需要转换
 *  2.泡泡需要支持自定义表情
 *  3.退格时，需要删除一整个“[xx]”
 *  4.需要添加“发送”按钮
 */

@protocol LJCChatEmojiInputViewDelegate <NSObject>
///< 退格
- (void)LJCChatEmojiInputViewDidTapBackspace;
///< 输入
- (void)LJCChatEmojiInputViewDidInputText:(NSString *)emojiText;
///< 发送
- (void)LJCChatEmojiInputViewDidSendEmoji;
@end

@interface LJCChatEmojiInputView : UIView
///< delegate
@property (nonatomic, weak) id<LJCChatEmojiInputViewDelegate> delegate;
@property (nonatomic, weak) id<UITextInput> firstResponder;

+ (instancetype)sharedInputView;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new  NS_UNAVAILABLE;
@end
