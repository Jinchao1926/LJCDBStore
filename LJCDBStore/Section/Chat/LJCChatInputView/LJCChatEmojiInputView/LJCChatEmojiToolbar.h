//
//  LJCChatEmojiToolbar.h
//  LJCDBStore
//
//  Created by 林锦超 on 01/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LJCChatEmojiToolbarDidSwitchEmojiGroup)(NSInteger groupIndex);
typedef void(^LJCChatEmojiToolbarDidSendEmoji)(void);
@interface LJCChatEmojiToolbar : UIView

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame names:(NSArray *)names;

@property (nonatomic, copy) LJCChatEmojiToolbarDidSwitchEmojiGroup switchEmojiGroupBlock;
@property (nonatomic, copy) LJCChatEmojiToolbarDidSendEmoji sendEmojiBlock;
@property (nonatomic, assign, getter=isSendEnable) BOOL sendEnable;

- (void)setToolbarButtonSelectedAtIndex:(NSInteger)groupIndex;
@end
