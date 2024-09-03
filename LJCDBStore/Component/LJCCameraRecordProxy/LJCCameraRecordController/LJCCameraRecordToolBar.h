//
//  LJCCameraRecordToolBar.h
//  LJCDBStore
//
//  Created by 林锦超 on 18/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LJCCameraRecordToolBarDidTaked)(BOOL isVideo);
typedef void(^LJCCameraRecordToolBarDidPaused)(void);

@interface LJCCameraRecordToolBar : UIView
@property (nonatomic, copy) LJCCameraRecordToolBarDidTaked takedHandler;
@property (nonatomic, copy) LJCCameraRecordToolBarDidPaused pausedHandler;
@end
