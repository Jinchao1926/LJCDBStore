//
//  LJCChatEmojiCell.h
//  LJCDBStore
//
//  Created by 林锦超 on 30/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJCChatEmotion;
@interface LJCChatEmojiCell : UICollectionViewCell

@property (nonatomic, assign, getter=isBackspace) BOOL backspace;
@property (nonatomic, strong, readonly) LJCChatEmotion *emotion;

- (void)configWithEmotion:(LJCChatEmotion *)emotion;
@end
