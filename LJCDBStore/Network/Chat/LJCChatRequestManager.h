//
//  LJCChatRequestManager.h
//  LJCDBStore
//
//  Created by 林锦超 on 27/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJCChatConst.h"

@class LJCChatModel;
@class LJCChatEmotionGroup;


@protocol LJCChatRequestManagerDelegate <NSObject>
@required
/** 消息加载完成
 *  @param messages 消息内容
 *  @param  more    是否加载更多(YES-是, NO-否)
 */
- (void)chatMessagesDidFetchCompletion:(NSArray<LJCChatModel *> *)messages isLoadMore:(BOOL)more;
- (void)chatMessageDidSendSuccess:(LJCChatModel *)message;
- (void)chatMessageDidSendFailed:(LJCChatModel *)message;
@end


@interface LJCChatRequestManager : NSObject
///< 聊天用户信息
@property (nonatomic, strong) NSDictionary *chatUserData;
///< delegate
@property (nonatomic, weak) id<LJCChatRequestManagerDelegate> delegate;

///< 消息列表
- (void)fetchChatMessages;
///< 清空消息列表
- (BOOL)clearAllChatMessages;

///< 发送文字
- (LJCChatModel *)sendChatTextMessage:(NSString *)text;
///< 发送图片
- (LJCChatModel *)sendChatImageMessage:(UIImage *)image;
///< 发送视频
- (LJCChatModel *)sendChatVideoMessage:(NSURL *)videoURL duration:(NSTimeInterval)duration withCoverImage:(UIImage *)image emptyOriginal:(BOOL)isEmpty;

///< 获取表情包
- (NSArray<LJCChatEmotionGroup *> *)fetchEmoticonGroups;
@end


extern NSString *const LJCChatRequestManagerFromUserId;
extern NSString *const LJCChatRequestManagerFromUserName;
extern NSString *const LJCChatRequestManagerToUserId;
extern NSString *const LJCChatRequestManagerToUserName;
