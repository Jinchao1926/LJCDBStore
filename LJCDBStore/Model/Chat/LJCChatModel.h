//
//  LJCChatModel.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJCChatConst.h"

@interface LJCChatModel : NSObject

@property (nonatomic, assign) NSInteger chatId;         ///< 本地id，包含上传失败的记录，作为主键
@property (nonatomic, assign) NSInteger chatServerId;   ///< 后台id
@property (nonatomic, copy) NSString *fromUserId;
@property (nonatomic, copy) NSString *fromUserName;
@property (nonatomic, strong) NSURL *fromUserAvatarURL;
@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, copy) NSString *toUserName;
@property (nonatomic, strong) NSURL *toUserAvatarURL;
@property (nonatomic, strong) NSDate *createTime;               //创建时间，yyyy-MM-dd HH:mm:ss

@property (nonatomic, assign) LJCChatSourceType chatType;
@property (nonatomic, assign) LJCChatSendState sendState;
@property (nonatomic, assign) LJCChatReadState readState;

///< 文本内容
@property (nonatomic, copy) NSString *content;

///< 图片／视频／语音
@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSURL *fileURL;

///< 视频缩略图
@property (nonatomic, copy) NSString *thumbFileId;
@property (nonatomic, copy) NSString *thumbFileName;
@property (nonatomic, copy) NSURL *thumbFileURL;

///< 语音时长
@property (nonatomic, copy) NSString *duration;

///< 图片／视频缩略图大小
@property (nonatomic, assign) CGFloat photoWidth;
@property (nonatomic, assign) CGFloat photoHeight;

#pragma mark -
@property (nonatomic, assign) BOOL isFromSelf;
@end
