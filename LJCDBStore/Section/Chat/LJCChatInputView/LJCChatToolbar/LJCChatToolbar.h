//
//  LJCChatToolbar.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJCChatConst.h"

typedef void(^LJCChatToolbarWillSendTextMessage)(NSString *message);
typedef void(^LJCChatToolbarWillSendImageMessage)(UIImage *image);
typedef void(^LJCChatToolbarWillSendVideoMessage)(NSURL *videoURL, NSTimeInterval duration, UIImage *coverImage, BOOL emptyOriginal);

@interface LJCChatToolbar : UIView

@property (nonatomic, copy) LJCChatToolbarWillSendTextMessage textMessageSender;
@property (nonatomic, copy) LJCChatToolbarWillSendImageMessage imageMessageSender;
@property (nonatomic, copy) LJCChatToolbarWillSendVideoMessage videoMessageSender;
@end
