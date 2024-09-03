//
//  LJCChatPhotoBrowserProxy.m
//  LJCDBStore
//
//  Created by 林锦超 on 11/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatPhotoBrowserProxy.h"
#import "LJCChatStore.h"
#import "YYCache+LJCFactory.h"

@implementation LJCChatPhotoBrowserProxy

- (instancetype)init
{
    return [self initWithChatId:@""];
}

- (instancetype)initWithChatId:(NSString *)chatId
{
    if (self = [super init]) {
        self.proxyType = LJCPhotoBrowserProxyChat;
        [self.photos removeAllObjects];
        
        NSArray<LJCChatModel *> *chats = [LJCChatStore chatImageReleatedMessage];
        [chats enumerateObjectsUsingBlock:^(LJCChatModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.chatType == LJCChatSourceTypePhoto) {
                UIImage *image = (UIImage *)[[YYCache chatImageCache] objectForKey:obj.fileURL.absoluteString];
                MWPhoto *photo = [MWPhoto photoWithImage:image];
                photo.tag = obj.chatId;
                [self.photos addObject:photo];
            }
            else if (obj.chatType == LJCChatSourceTypeVideo) {
                YYDiskCache *cache = [YYCache chatVideoCache].diskCache;
                NSString *cacheName = cache.customFileNameBlock(obj.fileURL.absoluteString);
                NSString *path = [[YYCache chatVideoCachePath] stringByAppendingPathComponent:cacheName];
                
                /// 视频显示缩略图
                UIImage *thumbImage = (UIImage *)[[YYCache chatImageCache] objectForKey:obj.thumbFileURL.absoluteString];
                MWPhoto *photo = [MWPhoto photoWithImage:thumbImage];
                photo.videoURL = [NSURL fileURLWithPath:path];
                photo.tag = obj.chatId;
                [self.photos addObject:photo];
            }
        }];
    }
    return self;
}

- (void)presentPhotoBrowserWithChatId:(NSInteger)chatId
{
    [self.photos enumerateObjectsUsingBlock:^(MWPhoto * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.tag == chatId) {
            
            [self presentPhotoBrowserWithIndex:idx];
            *stop = YES;
        }
    }];
}
@end
