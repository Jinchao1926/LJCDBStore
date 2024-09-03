//
//  LJCCameraRecordPreviewToolbar.m
//  LJCDBStore
//
//  Created by 林锦超 on 19/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCCameraRecordPreviewToolbar.h"

@interface LJCCameraRecordPreviewToolbar()
@property (nonatomic, strong) UIButton *retakeButton;
@property (nonatomic, strong) UIButton *doneButton;
@end

@implementation LJCCameraRecordPreviewToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.retakeButton];
        [self addSubview:self.doneButton];
        
        [self p_layoutSubViews];
    }
    return self;
}

- (void)p_layoutSubViews
{
    CGFloat padding = 20;
    CGFloat length = 60;
    self.retakeButton.frame = CGRectMake(0, padding, length, length);
    self.retakeButton.centerX = self.centerX;
    self.doneButton.frame = self.retakeButton.frame;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        [UIView animateWithDuration:0.2f animations:^{
            self.doneButton.right += 40;
            self.retakeButton.left -= 40;
        }];
    }
}

#pragma mark - Action
- (IBAction)handleRetakeButtonPressed:(id)sender
{
    if (self.retakedHandler) {
        self.retakedHandler();
    }
}

- (IBAction)handleDoneButtonPressed:(id)sender
{
    if (self.doneHandler) {
        self.doneHandler();
    }
}

#pragma mark - Getter
- (UIButton *)retakeButton
{
    if (!_retakeButton) {
        _retakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _retakeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_retakeButton setBackgroundImage:[UIImage imageNamed:@"camera_press"] forState:UIControlStateNormal];
        [_retakeButton setTitle:@"返回" forState:UIControlStateNormal];
        [_retakeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_retakeButton addTarget:self action:@selector(handleRetakeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retakeButton;
}

- (UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doneButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_doneButton setBackgroundImage:[UIImage imageNamed:@"camera_press"] forState:UIControlStateNormal];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(handleDoneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

@end
