//
//  LJCChatMoreCell.h
//  LJCDBStore
//
//  Created by 林锦超 on 04/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJCChatMoreConst.h"

@interface LJCChatMoreCell : UICollectionViewCell

@property (nonatomic, assign, readonly) LJCChatMoreCellType moreType;
- (void)configWithType:(LJCChatMoreCellType)moreType;
@end
