//
//  LJCCameraRecordTipsTool.h
//  LJCDBStore
//
//  Created by 林锦超 on 18/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LJCCameraRecordTipsToolDidSwitchedCameraOrientation)(void);
@interface LJCCameraRecordTipsTool : UIView

/// 是否录像模式，Default NO.
@property (nonatomic, assign, getter=isRecordEnable) BOOL recordEnable;
/// 录像时间
@property (nonatomic, copy) NSString *recordedDuration;

@property (nonatomic, copy) LJCCameraRecordTipsToolDidSwitchedCameraOrientation switchCameraOrientation;
@end
