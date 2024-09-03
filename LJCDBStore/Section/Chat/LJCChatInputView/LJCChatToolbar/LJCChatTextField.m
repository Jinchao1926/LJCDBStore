//
//  LJCChatTextField.m
//  LJCDBStore
//
//  Created by 林锦超 on 04/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatTextField.h"
#import "LJCChatHelper.h"

@implementation LJCChatTextField

- (void)deleteBackward
{
    NSArray<NSTextCheckingResult *> *emoticons = [[LJCChatHelper regexEmoticon] matchesInString:self.text options:kNilOptions range:self.text.rangeOfAll];
    
    if (emoticons.count > 0) {
        NSRange lastRange = emoticons.lastObject.range;
        
        ///< 刚好删除到表情 [xxx]
        if (lastRange.location + lastRange.length == self.text.length) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
                [self.delegate textField:self shouldChangeCharactersInRange:lastRange replacementString:@""];
            }
            
            for (int i = 0; i < lastRange.length; i++) {
                [super deleteBackward];
            }
            return;
        }
    }
    
    [super deleteBackward];
}

@end
