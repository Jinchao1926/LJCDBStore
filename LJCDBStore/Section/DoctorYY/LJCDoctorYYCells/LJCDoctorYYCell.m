//
//  LJCDoctorYYCell.m
//  LJCDBStore
//
//  Created by 林锦超 on 20/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCDoctorYYCell.h"
#import "LJCDoctorYYLayout.h"

@interface LJCDoctorYYCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *hospitalDeptLabel;
@property (nonatomic, strong) YYLabel *introduceLabel;
@end

@implementation LJCDoctorYYCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.containerView];
        
    }
    return self;
}

#pragma mark - Getter
- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        _containerView.backgroundColor = [UIColor cyanColor];
        _containerView.layer.cornerRadius = 4.f;
        
        [_containerView addSubview:self.avatarView];
        [_containerView addSubview:self.nameLabel];
        [_containerView addSubview:self.hospitalDeptLabel];
        [_containerView addSubview:self.introduceLabel];
    }
    return _containerView;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 48, 48)];
    }
    return _avatarView;
}

- (YYLabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[YYLabel alloc] init];
        _nameLabel.displaysAsynchronously = YES;
        _nameLabel.ignoreCommonProperties = YES;
        _nameLabel.fadeOnAsynchronouslyDisplay = NO;
        _nameLabel.fadeOnHighlight = NO;
        _nameLabel.lineBreakMode = NSLineBreakByClipping;
        _nameLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    }
    return _nameLabel;
}

- (YYLabel *)hospitalDeptLabel
{
    if (!_hospitalDeptLabel) {
        _hospitalDeptLabel = [[YYLabel alloc] init];
        _hospitalDeptLabel.displaysAsynchronously = YES;
        _hospitalDeptLabel.ignoreCommonProperties = YES;
        _hospitalDeptLabel.fadeOnAsynchronouslyDisplay = NO;
        _hospitalDeptLabel.fadeOnHighlight = NO;
        _hospitalDeptLabel.lineBreakMode = NSLineBreakByClipping;
        _hospitalDeptLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    }
    return _hospitalDeptLabel;
}

- (YYLabel *)introduceLabel
{
    if (!_introduceLabel) {
        _introduceLabel = [[YYLabel alloc] init];
        _introduceLabel.displaysAsynchronously = YES;
        _introduceLabel.ignoreCommonProperties = YES;
        _introduceLabel.fadeOnAsynchronouslyDisplay = NO;
        _introduceLabel.fadeOnHighlight = NO;
        _introduceLabel.lineBreakMode = NSLineBreakByClipping;
        _introduceLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
        _introduceLabel.numberOfLines = 0;
//        _introduceLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 48 - 12*3;
    }
    return _introduceLabel;
}

#pragma mark - Setter
- (void)configWithLayout:(LJCDoctorYYLayout *)layout
{
    self.height = layout.height;
    self.contentView.height = layout.height;
    self.containerView.size = layout.containerSize;
    self.containerView.left = kYYCellMargin;
    self.containerView.top = kYYCellMargin;
    
    [self.avatarView setImageWithURL:layout.doctor.avatarURL placeholder:nil options:/*YYWebImageOptionProgressive*/YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        NSLog(@"setImageWithURL from:%zd", from);
    }];
    self.avatarView.frame = CGRectMake(kYYCellAvatarMargin, kYYCellAvatarMargin, kYYCellAvatarSize, kYYCellAvatarSize);
    
    CGFloat top = kYYCellNameMargin;
    CGFloat left = CGRectGetMaxX(self.avatarView.frame) + kYYCellNameMargin;
    
    self.nameLabel.frame = CGRectMake(left, top, kYYCellNameWidth, kYYCellNameHeight);
    self.nameLabel.textLayout = layout.nameLayout;
    top += layout.nameHeight;
    
    self.hospitalDeptLabel.frame = CGRectMake(left, top, kYYCellNameWidth, kYYCellHospitalDeptHeight);
    self.hospitalDeptLabel.textLayout = layout.hospitalDeptLayout;
    top += layout.hospitalDeptHeight;
    
    self.introduceLabel.frame = CGRectMake(left, top, kYYCellNameWidth, layout.introduceHeight);
    self.introduceLabel.textLayout = layout.introduceLayout;
}

@end
