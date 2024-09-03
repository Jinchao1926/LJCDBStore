//
//  LJCCameraRecordPreviewToolbar.h
//  LJCDBStore
//
//  Created by 林锦超 on 19/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LJCCameraRecordPreviewToolbarDidRetaked)(void);
typedef void(^LJCCameraRecordPreviewToolbarDidDone)(void);

@interface LJCCameraRecordPreviewToolbar : UIView

@property (nonatomic, copy) LJCCameraRecordPreviewToolbarDidRetaked retakedHandler;
@property (nonatomic, copy) LJCCameraRecordPreviewToolbarDidDone doneHandler;
@end
