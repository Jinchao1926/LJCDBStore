//
//  LJCCameraRecordTipsTool.m
//  LJCDBStore
//
//  Created by 林锦超 on 18/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCCameraRecordTipsTool.h"

@interface LJCCameraRecordTipsTool()
@property (nonatomic, strong) UIButton *frontOrRear;    //Default rear
@property (nonatomic, strong) UILabel *timeRecordedLabel;
@end
@implementation LJCCameraRecordTipsTool

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.frontOrRear];
        [self addSubview:self.timeRecordedLabel];
        
        [self p_layoutSubViews];
        
        self.recordEnable = NO;
    }
    return self;
}

- (void)p_layoutSubViews
{
    [self.frontOrRear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.left.and.top.mas_equalTo(self).offset(20);
    }];
    
    [self.timeRecordedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 22));
        make.top.mas_equalTo(self).offset(20);
        make.right.mas_equalTo(self).offset(-20);
    }];
}

#pragma mark - Action
- (IBAction)switchFrontOrRear:(id)sender
{
    if (self.switchCameraOrientation) {
        self.switchCameraOrientation();
    }
}

#pragma mark - Setter
- (void)setRecordEnable:(BOOL)recordEnable
{
    _recordEnable = recordEnable;
    
    self.timeRecordedLabel.hidden = !recordEnable;
}

- (void)setRecordedDuration:(NSString *)recordedDuration
{
    _recordedDuration = recordedDuration;
    
    self.timeRecordedLabel.text = recordedDuration;
}

#pragma mark - Getter
- (UIButton *)frontOrRear
{
    if (!_frontOrRear) {
        _frontOrRear = [UIButton buttonWithType:UIButtonTypeCustom];
        [_frontOrRear setImage:[UIImage imageNamed:@"camera_switch_rear"] forState:UIControlStateNormal];
        [_frontOrRear addTarget:self action:@selector(switchFrontOrRear:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _frontOrRear;
}

- (UILabel *)timeRecordedLabel
{
    if (!_timeRecordedLabel) {
        _timeRecordedLabel = [UILabel new];
        _timeRecordedLabel.font = [UIFont systemFontOfSize:16];
        _timeRecordedLabel.textColor = [UIColor whiteColor];
        _timeRecordedLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeRecordedLabel;
}

@end
