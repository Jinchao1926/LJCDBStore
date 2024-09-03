//
//  LJCCameraRecorderController.h
//  LJCDBStore
//
//  Created by 林锦超 on 18/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LJCCameraRecorderDelegate <NSObject>
/// 拍照完成
- (void)LJCCameraRecorderControllerDidFinishTakingPhoto:(UIImage *)image;
/// 录像完成
- (void)LJCCameraRecorderControllerDidFinishRecordingVideo:(NSURL *)videoURL duration:(NSTimeInterval)duration thumbnail:(UIImage *)thumbnail;
@end

@interface LJCCameraRecorderController : UIViewController

@property (nonatomic, weak) id<LJCCameraRecorderDelegate> delegate;
@end
