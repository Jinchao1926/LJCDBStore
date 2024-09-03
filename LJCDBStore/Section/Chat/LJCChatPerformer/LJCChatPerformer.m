//
//  LJCChatPerformer.m
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatPerformer.h"

@implementation LJCChatPerformer

+ (void)registerChatCellsForTableView:(UITableView *)tableView
{
    if (!tableView) {
        return;
    }
    
    [tableView registerClass:[LJCChatTextCell class] forCellReuseIdentifier:@"LJCChatTextCell"];
    [tableView registerClass:[LJCChatVoiceCell class] forCellReuseIdentifier:@"LJCChatVoiceCell"];
    [tableView registerClass:[LJCChatPhotoCell class] forCellReuseIdentifier:@"LJCChatPhotoCell"];
    [tableView registerClass:[LJCChatVideoCell class] forCellReuseIdentifier:@"LJCChatVideoCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"LJCChatEmptyCell"];
}

+ (UITableViewCell __kindof *)dequeueChatCellForTableView:(UITableView *)tableView withSourceType:(LJCChatSourceType)sourceType
{
    if (sourceType == LJCChatSourceTypeText) {
        return [tableView dequeueReusableCellWithIdentifier:@"LJCChatTextCell"];
    }
    else if (sourceType == LJCChatSourceTypeVoice) {
        return [tableView dequeueReusableCellWithIdentifier:@"LJCChatVoiceCell"];
    }
    else if (sourceType == LJCChatSourceTypePhoto) {
        return [tableView dequeueReusableCellWithIdentifier:@"LJCChatPhotoCell"];
    }
    else if (sourceType == LJCChatSourceTypeVideo) {
        return [tableView dequeueReusableCellWithIdentifier:@"LJCChatVideoCell"];
    }
    else {
        return [tableView dequeueReusableCellWithIdentifier:@"LJCChatEmptyCell"];
    }
}
@end
