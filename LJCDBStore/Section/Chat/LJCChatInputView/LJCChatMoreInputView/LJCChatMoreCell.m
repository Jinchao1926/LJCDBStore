//
//  LJCChatMoreCell.m
//  LJCDBStore
//
//  Created by 林锦超 on 04/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCChatMoreCell.h"

#define kMoreLabelHeight    13
#define kMoreLabelMarginTop 10

@interface LJCChatMoreCell()
@property (nonatomic, strong) UIImageView *moreImage;
@property (nonatomic, strong) UILabel *moreLabel;

@property (nonatomic, strong) NSArray<NSString *> *imageNames;
@property (nonatomic, strong) NSArray<NSString *> *imageTitles;
@property (nonatomic, assign, readwrite) LJCChatMoreCellType moreType;
@end
@implementation LJCChatMoreCell

#pragma mark - LifeCycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageTitles = @[ @"照片", @"拍照" ];
        _imageNames = @[ @"picture_chat", @"camera_chat" ];
        _moreType = NSNotFound;
        
        [self.contentView addSubview:self.moreImage];
        [self.contentView addSubview:self.moreLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.moreImage.center = CGPointMake(self.width / 2, (self.height - kMoreLabelHeight - kMoreLabelMarginTop) / 2);
    self.moreLabel.frame = CGRectMake(0, CGRectGetMaxY(self.moreImage.frame) + kMoreLabelMarginTop, self.width, kMoreLabelHeight);
}

#pragma mark - Getter
- (UIImageView *)moreImage
{
    if (!_moreImage) {
        _moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    }
    return _moreImage;
}

- (UILabel *)moreLabel
{
    if (!_moreLabel) {
        _moreLabel = [[UILabel alloc] init];
        _moreLabel.textAlignment = NSTextAlignmentCenter;
        _moreLabel.textColor = [UIColor lightGrayColor];
        _moreLabel.font = [UIFont systemFontOfSize:13];
    }
    return _moreLabel;
}

#pragma mark -
- (void)configWithType:(LJCChatMoreCellType)moreType
{
    if (_moreType == moreType || moreType >= self.imageTitles.count || moreType >= self.imageNames.count) {
        return;
    }
    _moreType = moreType;
    
    self.moreLabel.text = self.imageTitles[moreType];
    self.moreImage.image = [UIImage imageNamed:self.imageNames[moreType]];
}

@end
