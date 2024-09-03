//
//  LJCChatButton.m
//  LJCDBStore
//
//  Created by 林锦超 on 27/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatToggleButton.h"

@interface LJCChatToggleButton()
@property (nonatomic, strong) NSDictionary<NSNumber *, NSString*> *normalStatesMapping;
@property (nonatomic, strong) NSDictionary<NSNumber *, NSString*> *toggleStatesMapping;
@end

@implementation LJCChatToggleButton

+ (instancetype)buttonWithChatType:(LJCChatToggleButtonType)chatType
{
    LJCChatToggleButton *button = [LJCChatToggleButton new];
    button.chatType = chatType;
    return button;
}

- (instancetype)init
{
    if (self = [super init]) {
        _normalStatesMapping = @{ @(LJCChatToggleButtonTypeVoice) : @"chat_toolbar_voice",
                                  @(LJCChatToggleButtonTypeEmoji) : @"chat_toolbar_emotion",
                                  @(LJCChatToggleButtonTypeMore) : @"chat_toolbar_more",
                                  };
        _toggleStatesMapping = @{ @(LJCChatToggleButtonTypeVoice) : @"chat_toolbar_keyboard",
                                  @(LJCChatToggleButtonTypeEmoji) : @"chat_toolbar_keyboard",
                                  @(LJCChatToggleButtonTypeMore) : @"chat_toolbar_more",
                                  };
        _normalState = YES;
    }
    return self;
}

- (void)toggleState
{
    self.normalState = !self.isNormalState;
}

#pragma mark - Setter
- (void)setNormalState:(BOOL)normalState
{
    _normalState = normalState;
    
    NSString *normalImageName = normalState ? _normalStatesMapping[@(self.chatType)] : _toggleStatesMapping[@(self.chatType)];
    NSString *highlightImageName = [NSString stringWithFormat:@"%@_HL", normalImageName];
    [self setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];   
}

- (void)setChatType:(LJCChatToggleButtonType)chatType
{
    if (_chatType == chatType) {
        return;
    }
    _chatType = chatType;
    
    self.normalState = self.isNormalState;
}
@end
