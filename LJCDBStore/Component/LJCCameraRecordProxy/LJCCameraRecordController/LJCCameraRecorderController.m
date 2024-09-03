//
//  LJCCameraRecorderController.m
//  LJCDBStore
//
//  Created by 林锦超 on 18/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCCameraRecorderController.h"
#import "LJCCameraRecordTipsTool.h"
#import "LJCCameraRecordToolBar.h"
#import "LJCCameraRecordPreviewView.h"
#import "SCRecorder.h"

#define kVideoPreset AVCaptureSessionPresetHigh
#define kPhotoPreset AVCaptureSessionPresetPhoto

@interface LJCCameraRecorderController ()<SCRecorderDelegate>
@property (nonatomic, strong) SCRecorder *recorder;
@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, strong) UIView *previewView;
@property (nonatomic, strong) LJCCameraRecordTipsTool *tipsTool;
@property (nonatomic, strong) LJCCameraRecordToolBar *toolbar;
@property (nonatomic, strong) LJCCameraRecordPreviewView *recordPlayView;
@end

@implementation LJCCameraRecorderController

#pragma mark - LifeCycle
- (void)dealloc
{
    _recorder.previewView = nil;
    
    NSLog(@"dealloc LJCCameraRecorderController.");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.previewView];
    [self p_layoutSubViews];
    
    if (!TARGET_OS_SIMULATOR) {
        NSError *error;
        if (![self.recorder prepare:&error]) {
            NSLog(@"Prepare error: %@", error.localizedDescription);
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!TARGET_OS_SIMULATOR) {
        [self prepareSession];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!TARGET_OS_SIMULATOR) {
        [self.recorder startRunning];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!TARGET_OS_SIMULATOR) {
        [self.recorder stopRunning];
    }
}

- (void)p_layoutSubViews
{
    [self.tipsTool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.previewView).offset(kStatusHeight);
        make.left.and.right.mas_equalTo(self.previewView);
        make.height.mas_equalTo(100);
    }];
    
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.previewView).offset(-kUnsafeBottomHeight);
        make.left.and.right.mas_equalTo(self.previewView);
        make.height.mas_equalTo(200);
    }];
}

#pragma mark - Getter
- (SCRecorder *)recorder
{
    if (!_recorder) {
        _recorder = [SCRecorder recorder];
        _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
//        _recorder.maxRecordDuration = CMTimeMake(10, 1);
        _recorder.fastRecordMethodEnabled = YES;
        
        _recorder.delegate = self;
        _recorder.autoSetVideoOrientation = NO; //YES causes bad orientation for video from camera roll
        _recorder.initializeSessionLazily = NO;
        _recorder.previewView = self.previewView;
    }
    return _recorder;
}

- (UIView *)previewView
{
    if (!_previewView) {
        _previewView = [[UIView alloc] initWithFrame:self.view.bounds];
        
        [_previewView addSubview:self.tipsTool];
        [_previewView addSubview:self.toolbar];
    }
    return _previewView;
}

- (LJCCameraRecordTipsTool *)tipsTool
{
    if (!_tipsTool) {
        _tipsTool = [LJCCameraRecordTipsTool new];
        
        @weakify(self)
        _tipsTool.switchCameraOrientation = ^{
            @strongify(self)
            [self.recorder switchCaptureDevices];
        };
    }
    return _tipsTool;
}

- (LJCCameraRecordToolBar *)toolbar
{
    if (!_toolbar) {
        _toolbar = [LJCCameraRecordToolBar new];
        
        @weakify(self)
        _toolbar.takedHandler = ^(BOOL isVideo) {
            @strongify(self)
            self.isVideo = isVideo;
            self.tipsTool.recordEnable = isVideo;
            
            if (self.isVideo) {
                // video
//                self.recorder.captureSessionPreset = kVideoPreset;
                [self.recorder record];
            }
            else {
                // photo
//                self.recorder.captureSessionPreset = kPhotoPreset;
                [self p_takePhoto];
            }
        };
        _toolbar.pausedHandler = ^{
            @strongify(self)
            if (self.isVideo) {
                [self p_stopRecording];
                self.tipsTool.recordEnable = NO;
            }
        };
    }
    return _toolbar;
}

#pragma mark -
- (void)prepareSession
{
    if (!self.recorder.session) {
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeQuickTimeMovie;
        self.recorder.session = session;
    }
    
    [self p_updateTimeRecordedLabel];
}

- (void)p_stopRecording
{
    @weakify(self)
    [self.recorder pause:^{
        @strongify(self)
        @autoreleasepool {
            LJCCameraRecordPreviewView *previewView = [[LJCCameraRecordPreviewView alloc] initWithFrame:self.view.bounds];
            previewView.recordSession = self.recorder.session;
            
            @weakify(self)
            previewView.videoHandler = ^(NSURL *videoURL, NSTimeInterval duration, UIImage *thumbnail) {
                @strongify(self)
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(LJCCameraRecorderControllerDidFinishRecordingVideo:duration:thumbnail:)]) {
                    [self.delegate LJCCameraRecorderControllerDidFinishRecordingVideo:videoURL duration:duration thumbnail:thumbnail];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            };
            [self.view addSubview:previewView];
        }
    }];
}

- (void)p_takePhoto
{
    @weakify(self)
    [self.recorder capturePhoto:^(NSError *error, UIImage *image) {
        @strongify(self)
        
        if (image != nil) {
            @autoreleasepool {
                LJCCameraRecordPreviewView *previewView = [[LJCCameraRecordPreviewView alloc] initWithFrame:self.view.bounds];
                previewView.photo = image;
                
                @weakify(self)
                previewView.imageHandler = ^(UIImage *image) {
                    @strongify(self)
                    if (self.delegate && [self.delegate respondsToSelector:@selector(LJCCameraRecorderControllerDidFinishTakingPhoto:)]) {
                        [self.delegate LJCCameraRecorderControllerDidFinishTakingPhoto:image];
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                };
                [self.view addSubview:previewView];
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            });
        }
    }];
}

- (void)p_updateTimeRecordedLabel
{
    CMTime currentTime = kCMTimeZero;
    if (self.recorder.session) {
        currentTime = self.recorder.session.duration;
    }
    self.tipsTool.recordedDuration = [NSString stringWithFormat:@"%.2f sec", CMTimeGetSeconds(currentTime)];
}

#pragma mark - SCRecorderDelegate
///< 音频初始化完成
- (void)recorder:(SCRecorder *)recorder didInitializeAudioInSession:(SCRecordSession *)recordSession error:(NSError *)error
{
    if (error == nil) {
        NSLog(@"Initialized audio in record session");
    } else {
        NSLog(@"Failed to initialize audio in record session: %@", error.localizedDescription);
    }
}
///< 视频初始化完成
- (void)recorder:(SCRecorder *)recorder didInitializeVideoInSession:(SCRecordSession *)recordSession error:(NSError *)error
{
    if (error == nil) {
        NSLog(@"Initialized video in record session");
    } else {
        NSLog(@"Failed to initialize video in record session: %@", error.localizedDescription);
    }
}
///< 开始一段session
- (void)recorder:(SCRecorder *)recorder didBeginSegmentInSession:(SCRecordSession *)recordSession error:(NSError *)error
{
    NSLog(@"Began record segment: %@", error);
}
///< 结束一段session
- (void)recorder:(SCRecorder *)recorder didCompleteSegment:(SCRecordSessionSegment *)segment inSession:(SCRecordSession *)recordSession error:(NSError *)error
{
    NSLog(@"Completed record segment at %@: %@ (frameRate: %f)", segment.url, error, segment.frameRate);
    //    [self updateGhostImage];
}
///< 添加一段视频流
- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession
{
    [self p_updateTimeRecordedLabel];
}

- (void)recorder:(SCRecorder *)recorder didSkipVideoSampleBufferInSession:(SCRecordSession *)recordSession
{
    NSLog(@"Skipped video buffer");
}

- (void)recorder:(SCRecorder *)recorder didReconfigureAudioInput:(NSError *)audioInputError
{
    NSLog(@"Reconfigured audio input: %@", audioInputError);
}

- (void)recorder:(SCRecorder *)recorder didReconfigureVideoInput:(NSError *)videoInputError
{
    NSLog(@"Reconfigured video input: %@", videoInputError);
}

- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)recordSession
{
    NSLog(@"didCompleteSession:");
//    [self saveAndShowSession:recordSession];
}



@end
