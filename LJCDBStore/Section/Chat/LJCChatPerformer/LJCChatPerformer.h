//
//  LJCChatPerformer.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJCChatTextCell.h"
#import "LJCChatVoiceCell.h"
#import "LJCChatPhotoCell.h"
#import "LJCChatVideoCell.h"
#import "LJCChatConst.h"

@interface LJCChatPerformer : NSObject

+ (void)registerChatCellsForTableView:(UITableView *)tableView;
+ (UITableViewCell __kindof *)dequeueChatCellForTableView:(UITableView *)tableView
                                           withSourceType:(LJCChatSourceType)sourceType;
@end
