//
//  LJCChatLayout.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJCChatLayoutConst.h"
#import "LJCChatModel.h"

@interface LJCChatLayout : NSObject

@property (nonatomic, strong) LJCChatModel *chat;

///
@property (nonatomic, assign) CGFloat marginTop;

/// 时间
@property (nonatomic, assign) CGFloat timeHeight;
@property (nonatomic, assign) CGFloat timeWidth;
@property (nonatomic, strong) YYTextLayout *timeTextLayout;

/// 泡泡
@property (nonatomic, assign) CGFloat bubbleMarginTop;
@property (nonatomic, assign) CGFloat bubbleHeight;
@property (nonatomic, assign) CGFloat bubbleWidth;

/// 文字消息
@property (nonatomic, assign) CGFloat bubbleTextHeight;
@property (nonatomic, assign) CGFloat bubbleTextWidth;
@property (nonatomic, strong) YYTextLayout *bubbleTextLayout;

/// 视频消息
@property (nonatomic, assign) CGFloat videoDurationHeight;
@property (nonatomic, assign) CGFloat videoDurationWidth;
@property (nonatomic, strong) YYTextLayout *videoDurationTextLayout;

/// 语音消息
@property (nonatomic, assign) CGFloat bubbleVoiceHeight;

///
@property (nonatomic, assign) CGFloat marginBottom;

@property (nonatomic, assign) CGFloat height;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithChat:(LJCChatModel *)chat;
- (void)layout;
@end
