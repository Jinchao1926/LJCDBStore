//
//  LJCChatButton.h
//  LJCDBStore
//
//  Created by 林锦超 on 27/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LJCChatToggleButtonType)
{
    LJCChatToggleButtonTypeUnknown = 0,
    LJCChatToggleButtonTypeVoice,
    LJCChatToggleButtonTypeEmoji,
    LJCChatToggleButtonTypeMore,
};

@interface LJCChatToggleButton : UIButton

@property (nonatomic, assign) LJCChatToggleButtonType chatType;
@property (nonatomic, assign, getter=isNormalState) BOOL normalState;

+ (instancetype)buttonWithChatType:(LJCChatToggleButtonType)chatType;

- (void)toggleState;
@end
