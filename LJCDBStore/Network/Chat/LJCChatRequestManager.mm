//
//  LJCChatRequestManager.m
//  LJCDBStore
//
//  Created by 林锦超 on 27/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatRequestManager.h"
#import "LJCChatStore.h"
#import "LJCChatFTSStore.h"
#import "LJCChatModel+WCTTableCoding.h"
#import "LJCChatFTSModel+WCTTableCoding.h"
#import "LJCChatEmotion.h"

#import "NSString+LJCDateString.h"
#import "LJCVideoHelper.h"
//LJCChatRequest

NSString *const LJCChatRequestManagerFromUserId = @"LJCChatRequestManagerFromUserId";
NSString *const LJCChatRequestManagerFromUserName = @"LJCChatRequestManagerFromUserName";
NSString *const LJCChatRequestManagerToUserId = @"LJCChatRequestManagerToUserId";
NSString *const LJCChatRequestManagerToUserName = @"LJCChatRequestManagerToUserName";

@interface LJCChatRequestManager()
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, assign) NSUInteger limit;
@end
@implementation LJCChatRequestManager

- (instancetype)init
{
    if (self = [super init]) {
        _page = 1;
        _limit = 10;
    }
    return self;
}

#pragma mark - Public
///< 消息列表
- (void)fetchChatMessages
{
    // db cache
    NSArray<LJCChatModel *> *datas = [LJCChatStore chatMessagesWithRange:NSMakeRange(_limit * (_page - 1), _limit)];
    if (datas.count > 0) {
        NSLog(@"db cached");
        ++_page;
    }
    
//    NSLog(@"datas:%@", datas);
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatMessagesDidFetchCompletion:isLoadMore:)]) {
        [self.delegate chatMessagesDidFetchCompletion:datas isLoadMore:(_page != 2)];   //++_page过
    }
    
    // 这里添加Http request
}

///< 清空消息列表
- (BOOL)clearAllChatMessages
{
    BOOL clear = [LJCChatStore clearChatMessages] && [LJCChatFTSStore clearChatFTSMessages];
    if (clear) {
        _page = 1;
    }
    return clear;
}

///< 发送文本
- (LJCChatModel *)sendChatTextMessage:(NSString *)text
{
    LJCChatModel *chat = [self p_commonChatModel];
    chat.chatType = LJCChatSourceTypeText;
    chat.content = text;
    [LJCChatStore insertChatMessage:chat];
    
    // 1s delay, simulate HTTP Request
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        chat.chatServerId = chat.chatId;    //获取服务id
        chat.createTime = [NSDate date];    //更新时间
        
        // replace
        BOOL replace = [LJCChatStore replaceChatMessage:chat];
        NSLog(@"replace:%d", replace);
        
        // sync FTS
        [LJCChatFTSStore insertChatFTSMessageWithOrigin:chat];
        
        [self p_chatMessageSendCompletely:chat success:replace];
    });
    
    return chat;
}
///< 发送图片
- (LJCChatModel *)sendChatImageMessage:(UIImage *)image
{
    /// image_yyyyMMddHHmmssSSSS，后续替换为image_chatId_fileId
    NSString *cacheName = [NSString stringWithFormat:@"image_%@", [NSString stringWithCurrentDate]];
    [[YYCache chatImageCache] setObject:image forKey:cacheName];
    
//    NSData *data = UIImageJPEGRepresentation(image, 1);
//    NSLog(@"data.length:%lf(KB)", data.length / 1024.f);
    
    LJCChatModel *chat = [self p_commonChatModel];
    chat.chatType = LJCChatSourceTypePhoto;
    chat.fileURL = [NSURL URLWithString:cacheName];
    chat.photoWidth = round(image.size.width);
    chat.photoHeight = round(image.size.height);
    [LJCChatStore insertChatMessage:chat];
 
    // 1s delay, simulate HTTP Request
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        chat.chatServerId = chat.chatId;    //获取服务id
        chat.createTime = [NSDate date];    //更新时间
        chat.fileId = [NSString stringWithFormat:@"image_%zd_001", chat.chatServerId];

        NSString *oldCachePath = chat.fileURL.absoluteString;
//        NSString *newCachePath = [[oldCachePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:chat.fileId];

        // recache
        chat.fileURL = [self p_recacheFile:chat.fileURL withId:chat.fileId inCache:[YYCache chatImageCache]];

        // replace
        BOOL replace = [LJCChatStore replaceChatMessage:chat];
        NSLog(@"replace:%d", replace);
        [self p_chatMessageSendCompletely:chat success:replace];
    });
    
    return chat;
}
///< 发送视频
- (LJCChatModel *)sendChatVideoMessage:(NSURL *)videoURL duration:(NSTimeInterval)duration withCoverImage:(UIImage *)image emptyOriginal:(BOOL)isEmpty
{
    /// cache video_yyyyMMddHHmmssSSSS，后续替换为image_chatId_fileId
    NSString *timestamp = [NSString stringWithCurrentDate];
    NSString *videoCacheName = [NSString stringWithFormat:@"video_%@", timestamp];
    NSString *thumbCacheName = [NSString stringWithFormat:@"videoThumb_%@", timestamp];
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
    [[YYCache chatImageCache] setObject:image forKey:thumbCacheName];
    [[YYCache chatVideoCache] setObject:videoData forKey:videoCacheName];
    
//    NSData *data = UIImageJPEGRepresentation(image, 1);
//    NSLog(@"video.length:%lf(KB) thumb.length:%lf(KB)", videoData.length / 1024.f, data.length / 1024.f);
    
    LJCChatModel *chat = [self p_commonChatModel];
    chat.chatType = LJCChatSourceTypeVideo;
    chat.fileURL = [NSURL URLWithString:videoCacheName];
    chat.thumbFileURL = [NSURL URLWithString:thumbCacheName];
    chat.photoWidth = image.size.width;
    chat.photoHeight = image.size.height;
    chat.duration = [LJCVideoHelper durationWithVideoTimeInterval:duration];
    
    ///< 移除之前导出的视频文件
    if (isEmpty) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSFileManager defaultManager] removeItemAtURL:videoURL error:nil];
        });
    }
    
    BOOL insert = [LJCChatStore insertChatMessage:chat];
    
    // 1s delay, simulate HTTP Request
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        chat.chatServerId = chat.chatId;    //获取服务id
        chat.createTime = [NSDate date];    //更新时间
        chat.fileId = [NSString stringWithFormat:@"video_%zd_001", chat.chatServerId];
        chat.thumbFileId = [NSString stringWithFormat:@"videoThumb_%zd_001", chat.chatServerId];
        
        // recache
        chat.fileURL = [self p_recacheFile:chat.fileURL withId:chat.fileId inCache:[YYCache chatVideoCache]];
        chat.thumbFileURL = [self p_recacheFile:chat.thumbFileURL withId:chat.thumbFileId inCache:[YYCache chatImageCache]];
        
        // replace
        BOOL replace = [LJCChatStore replaceChatMessage:chat];
        NSLog(@"replace:%d", replace);
        [self p_chatMessageSendCompletely:chat success:replace];
    });
    return chat;
}

#pragma mark -
- (LJCChatModel *)p_commonChatModel
{
    LJCChatModel *chat = [LJCChatModel new];
    chat.isAutoIncrement = YES;
    chat.fromUserId = self.chatUserData[LJCChatRequestManagerFromUserId];
    chat.fromUserName = self.chatUserData[LJCChatRequestManagerFromUserName];
//    chat.fromUserAvatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/image/getIcon/4/%@", LJC_BASE_URL, chat.fromUserId]];   // Invalid image server
    chat.fromUserAvatarURL = [NSURL URLWithString:@"https://avatars.githubusercontent.com/u/51687782?v=4"];
    chat.toUserId = self.chatUserData[LJCChatRequestManagerToUserId];
    chat.toUserName = self.chatUserData[LJCChatRequestManagerToUserName];
//    chat.toUserAvatarURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/image/getIcon/4/%@", LJC_BASE_URL, chat.toUserId]];
    chat.toUserAvatarURL = [NSURL URLWithString:@"https://avatars.githubusercontent.com/u/22309582?v=4"];
    
    chat.createTime = [NSDate new];
    chat.sendState = LJCChatSendStateSending;
    chat.readState = LJCChatReaded;
    return chat;
}

- (void)p_chatMessageSendCompletely:(LJCChatModel *)chat success:(BOOL)success
{
    if (self.delegate) {
        if (success && [self.delegate respondsToSelector:@selector(chatMessageDidSendSuccess:)]) {
            [self.delegate chatMessageDidSendSuccess:chat];
        }
        else if (!success && [self.delegate respondsToSelector:@selector(chatMessageDidSendFailed:)]) {
            [self.delegate chatMessageDidSendFailed:chat];
        }
    }
}

- (NSURL *)p_recacheFile:(NSURL *)fileURL withId:(NSString *)fileId inCache:(YYCache *)cache
{
    if (!cache || !fileURL || !fileId) {
        return fileURL;
    }
    NSString *oldCachePath = fileURL.absoluteString;
    NSString *newCachePath = [[oldCachePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileId];
    
    // reCache
    [cache setObject:[cache objectForKey:oldCachePath] forKey:newCachePath];
    [cache removeObjectForKey:oldCachePath];
    
    // reSetter
    return [NSURL URLWithString:newCachePath];
}

#pragma mark - emoticon
///< 获取表情包分组
- (NSArray<LJCChatEmotionGroup *> *)fetchEmoticonGroups
{
    static NSMutableArray *groups;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *emoticonBundlePath = [[NSBundle mainBundle] pathForResource:@"EmoticonWeibo" ofType:@"bundle"];
        NSString *emoticonPlistPath = [emoticonBundlePath stringByAppendingPathComponent:@"emoticons.plist"];
        NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:emoticonPlistPath];
        NSArray *packages = plist[@"packages"];
        groups = [LJCChatEmotionGroup mj_objectArrayWithKeyValuesArray:packages];
        
        NSMutableDictionary *groupDic = [NSMutableDictionary new];
        for (NSInteger i = 0, max = groups.count; i < max; i++) {
            LJCChatEmotionGroup *group = groups[i];
            // 去除无效表情分组
            if (group.groupID.length == 0) {
                [groups removeObjectAtIndex:i];
                i--;
                max--;
                continue;
            }
            NSString *path = [emoticonBundlePath stringByAppendingPathComponent:group.groupID];
            NSString *infoPlistPath = [path stringByAppendingPathComponent:@"info.plist"];
            NSDictionary *info = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
            group = [LJCChatEmotionGroup mj_objectWithKeyValues:info];
            [groups replaceObjectAtIndex:i withObject:group];   //must replace!!!
            
            // 表情分组中没有表情包
            if (group.emoticons.count == 0) {
                i--;
                max--;
                continue;
            }
            groupDic[group.groupID] = group;
        }
        
        // 各组表情包的补丁表情
        NSArray<NSString *> *additionals = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[emoticonBundlePath stringByAppendingPathComponent:@"additional"] error:nil];
        for (NSString *path in additionals) {
            LJCChatEmotionGroup *group = groupDic[path];
            if (!group) {
                continue;
            }
            
            NSString *infoJSONPath = [[[emoticonBundlePath stringByAppendingPathComponent:@"additional"] stringByAppendingPathComponent:path] stringByAppendingPathComponent:@"info.json"];
            NSData *infoJSON = [NSData dataWithContentsOfFile:infoJSONPath];
            LJCChatEmotionGroup *addGroup = [LJCChatEmotionGroup mj_objectWithKeyValues:infoJSON];
            if (addGroup.emoticons.count) {
                for (LJCChatEmotion *emoticon in addGroup.emoticons) {
                    emoticon.group = group;
                }
                [((NSMutableArray *)group.emoticons) insertObjects:addGroup.emoticons atIndex:0];
            }
        }
    });
    
    return groups;
}

@end
