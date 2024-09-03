//
//  LJCChatLayoutConst.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#ifndef LJCChatLayoutConst_h
#define LJCChatLayoutConst_h

/// 时间
#define kChatTimeMargin     10

/// 头像
#define kChatAvatarMargin   10
#define kChatAvatarLength   40

/// 泡泡
#define kChatBubbleMargin   5
#define kChatBubbleMaxWidth (kScreenWidth - kChatBubbleMargin - kChatAvatarMargin - kChatAvatarLength * 2)

/// 文本
#define kChatTextMarginX    12
#define kChatTextMarginY    12
#define kChatTextMaxWidth   (kChatBubbleMaxWidth - 2*kChatTextMarginX - kChatBubbleMargin)  //箭头部分 kChatBubbleMargin

/// 图片
#define kChatPhotoMaxLength 120     //图片最大变长，根据最大值等比例适配

/// 视频
#define kChatVideoPlayLength        40
#define kChatVideoDurationMargin    5
#define kChatVideoDurationHeight    20

#endif /* LJCChatLayoutConst_h */
