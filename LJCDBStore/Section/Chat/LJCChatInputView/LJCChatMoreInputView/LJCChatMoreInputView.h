//
//  LJCChatMoreInputView.h
//  LJCDBStore
//
//  Created by 林锦超 on 23/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJCChatMoreConst.h"

@protocol LJCChatMoreInputViewDelegate <NSObject>
- (void)LJCChatMoreInputViewDidSelected:(LJCChatMoreCellType)moreType;
@end

@interface LJCChatMoreInputView : UIView
///< delegate
@property (nonatomic, weak) id<LJCChatMoreInputViewDelegate> delegate;

+ (instancetype)sharedInputView;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)new  NS_UNAVAILABLE;
@end
