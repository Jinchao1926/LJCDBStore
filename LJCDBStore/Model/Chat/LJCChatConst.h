//
//  LJCChatConst.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#ifndef LJCChatConst_h
#define LJCChatConst_h

#define LJCChatFromUserId   @"67AE58883F3749609F6F7E5796D7BD24"
#define LJCChatToUserId     @"3A73136B13EA4327BBE8CF80C13F9699"

///< 消息来源类型
typedef NS_ENUM(NSInteger, LJCChatSourceType)
{
    LJCChatSourceTypeText = 0,    // 文字
    LJCChatSourceTypePhoto,       // 图片
    LJCChatSourceTypeVoice,       // 声音
    LJCChatSourceTypeVideo,       // 视频
};

///< 消息文件流类型
typedef NS_ENUM(NSInteger, LJCChatStreamType)
{
    LJCChatStreamTypePhoto = 0,   // 图片
    LJCChatStreamTypeVoice,       // 声音
    LJCChatStreamTypeAudio,       // 视频
};

///< 消息发送状态
typedef NS_ENUM(NSInteger, LJCChatSendState)
{
    LJCChatSendStateSending,       // 消息正在发送
    LJCChatSendStateSuccess,       // 消息发送成功
    LJCChatSendStateFail,          // 消息发送失败
};

///< 消息读取状态
typedef NS_ENUM(NSInteger, LJCChatReadState)
{
    LJCChatUnRead,            // 消息未读
    LJCChatReaded,            // 消息已读
};

#endif /* LJCChatConst_h */
