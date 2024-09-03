//
//  LJCDoctorCell.m
//  LJCDBStore
//
//  Created by 林锦超 on 31/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCDoctorCell.h"
#import "LJCDoctorModel.h"

@interface LJCDoctorCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *hospitalDeptLabel;
@property (nonatomic, strong) UILabel *introduceLabel;
@end

@implementation LJCDoctorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.containerView];
        
        [self p_addMasonry];
    }
    return self;
}

- (void)p_addMasonry
{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10, 10, 0, 10));
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.containerView).mas_offset(12);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarView.mas_right).with.offset(12);
        make.top.equalTo(self.containerView).with.offset(16);   //self.containerView.mas_top
        make.right.equalTo(self.containerView).with.offset(-12);
        make.height.mas_equalTo(16);
    }];
    
    [self.hospitalDeptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).with.offset(10);
        make.height.mas_equalTo(13);
    }];
    
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.hospitalDeptLabel);
        make.top.equalTo(self.hospitalDeptLabel.mas_bottom).with.offset(10);
        make.bottom.equalTo(self.containerView).with.offset(-10);
    }];
}

- (void)layoutSubviews
{
    self.introduceLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.containerView.frame) - CGRectGetMinX(self.introduceLabel.frame) - 12;
    
    [super layoutSubviews];
}
//- (void)updateConstraints
//{
//    NSLog(@"updateConstraints");
//    [super updateConstraints];
//}

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

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 16, 300, 16)];
//        _nameLabel.displaysAsynchronously = YES;
//        _nameLabel.ignoreCommonProperties = YES;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)hospitalDeptLabel
{
    if (!_hospitalDeptLabel) {
        _hospitalDeptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 13)];
//        _hospitalDeptLabel.displaysAsynchronously = YES;
//        _hospitalDeptLabel.ignoreCommonProperties = YES;
        _hospitalDeptLabel.font = [UIFont systemFontOfSize:13];
        _hospitalDeptLabel.textColor = [UIColor blackColor];
    }
    return _hospitalDeptLabel;
}

- (UILabel *)introduceLabel
{
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 440, 13)];
//        _introduceLabel.displaysAsynchronously = YES;
//        _introduceLabel.ignoreCommonProperties = YES;
        _introduceLabel.font = [UIFont systemFontOfSize:13];
        _introduceLabel.textColor = [UIColor lightGrayColor];
        _introduceLabel.numberOfLines = 0;
        _introduceLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 48 - 12*3;
    }
    return _introduceLabel;
}

#pragma mark - Setter
- (void)configWithModel:(LJCDoctorModel *)model;
{
    self.avatarView.backgroundColor = [UIColor orangeColor];
    self.nameLabel.text = model.name;
    self.hospitalDeptLabel.text = [NSString stringWithFormat:@"%@ %@", model.hospitalName, model.deptName];
    self.introduceLabel.text = model.introduce ?: @"无";
    
//    self.introduceLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.containerView.frame) - CGRectGetMinX(self.introduceLabel.frame) - 12;
    
    
//    self.introduceLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width;
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
    
    model.cachedCellHeight = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
//    [self updateConstraintsIfNeeded];
}
@end
