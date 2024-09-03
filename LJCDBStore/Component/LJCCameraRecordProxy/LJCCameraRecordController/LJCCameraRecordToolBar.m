//
//  LJCCameraRecordToolBar.m
//  LJCDBStore
//
//  Created by 林锦超 on 18/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCCameraRecordToolBar.h"

@interface LJCCameraRecordToolBar()
@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UIButton *takeButton;

@property (nonatomic, assign) BOOL isVideo;
@end
@implementation LJCCameraRecordToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.dismissButton];
        [self addSubview:self.takeButton];
        
        [self p_layoutSubViews];
    }
    return self;
}

- (void)p_layoutSubViews
{
    [self.takeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(20);
    }];
    
    [self.dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(self.takeButton);
        make.right.mas_equalTo(self.takeButton.mas_left).offset(-20);
    }];
}

#pragma mark - Action
- (IBAction)handleDismissButtonPressed:(id)sender
{
    [[UIViewController ljc_topMostViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleTakeButtonLongTouchDetector:(UILongPressGestureRecognizer *)longGR
{
    if (longGR.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        self.isVideo = YES;
        
        if (self.takedHandler) {
            self.takedHandler(self.isVideo);
        }
    }
    else if (longGR.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        
        if (self.pausedHandler) {
            self.pausedHandler();
        }
    }
}

- (IBAction)handleTakeButtonPressed:(id)sender
{
    NSLog(@"handleTakeButtonPressed");
    self.isVideo = NO;
    
    if (self.takedHandler) {
        self.takedHandler(self.isVideo);
    }
}

#pragma mark - Getter
- (UIButton *)dismissButton
{
    if (!_dismissButton) {
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dismissButton setImage:[UIImage imageNamed:@"camera_spread"] forState:UIControlStateNormal];
        [_dismissButton addTarget:self action:@selector(handleDismissButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissButton;
}

- (UIButton *)takeButton
{
    if (!_takeButton) {
        _takeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takeButton setBackgroundImage:[UIImage imageNamed:@"camera_press"] forState:UIControlStateNormal];
        [_takeButton addTarget:self action:@selector(handleTakeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTakeButtonLongTouchDetector:)];
        longPressGR.minimumPressDuration = 1.f;
        [_takeButton addGestureRecognizer:longPressGR];
    }
    return _takeButton;
}

@end
