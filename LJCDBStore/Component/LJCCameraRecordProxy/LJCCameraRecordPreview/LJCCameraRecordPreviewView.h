//
//  LJCCameraRecordPreviewView.h
//  LJCDBStore
//
//  Created by 林锦超 on 19/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCRecorder.h"

typedef void(^LJCCameraRecordPreviewViewImageCompletionHandler)(UIImage *image);
typedef void(^LJCCameraRecordPreviewViewVideoCompletionHandler)(NSURL *videoURL, NSTimeInterval duration, UIImage *thumbnail);
@interface LJCCameraRecordPreviewView : UIView

@property (nonatomic, strong) SCRecordSession *recordSession;
@property (nonatomic, strong) UIImage *photo;

@property (nonatomic, copy) LJCCameraRecordPreviewViewImageCompletionHandler imageHandler;
@property (nonatomic, copy) LJCCameraRecordPreviewViewVideoCompletionHandler videoHandler;
@end
