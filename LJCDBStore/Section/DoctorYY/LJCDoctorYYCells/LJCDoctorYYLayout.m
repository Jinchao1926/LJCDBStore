//
//  LJCDoctorYYLayout.m
//  LJCDBStore
//
//  Created by 林锦超 on 20/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCDoctorYYLayout.h"

@interface LJCDoctorYYLayout()

@end
@implementation LJCDoctorYYLayout

- (instancetype)initWithDoctor:(LJCDoctorModel *)doctor
{
    if (self = [super init]) {
        _doctor = doctor;
        
        [self p_layout];
        
    }
    return self;
}

- (void)p_layout
{
    _marginTop = kYYCellMargin;
    _nameHeight = kYYCellNameHeight;
    _hospitalDeptHeight = kYYCellHospitalDeptHeight;
    _marginBottom = kYYCellMargin;
    
    [self p_layoutName];
    [self p_layoutHospitalDept];
    [self p_layoutIntroduce];
    
    _height = 0.f;
    _height += (_marginTop + kYYCellNameMargin);
    _height += _nameHeight;
    _height += _hospitalDeptHeight;
    _height += _introduceHeight;
    _height += _marginBottom;
    
    _containerSize = CGSizeMake(kScreenWidth - 2*kYYCellMargin, _height - _marginTop);
}

- (void)p_layoutName
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_doctor.name];
    text.color = [UIColor blackColor];
    text.font = [UIFont systemFontOfSize:16];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kYYCellNameWidth, kYYCellNameHeight)];
    _nameLayout = [YYTextLayout layoutWithContainer:container text:text];
}

- (void)p_layoutHospitalDept
{
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", _doctor.hospitalName, _doctor.deptName]];
    text.color = [UIColor blackColor];
    text.font = [UIFont systemFontOfSize:13];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(_nameLayout.container.size.width, _hospitalDeptHeight)];
    _hospitalDeptLayout = [YYTextLayout layoutWithContainer:container text:text];
}

- (void)p_layoutIntroduce
{
    _introduceLayout = nil;
    _introduceHeight = 0.f;
    
    if (_doctor.introduce.length == 0) {
        return;
    }
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_doctor.introduce ?: @""];
    text.color = [UIColor lightGrayColor];
    text.font = [UIFont systemFontOfSize:13];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(_nameLayout.container.size.width, MAXFLOAT)];
    _introduceLayout = [YYTextLayout layoutWithContainer:container text:text];
    _introduceHeight = _introduceLayout.textBoundingSize.height;
    
//    NSLog(@"_introduceLayout.rowCount:%zd _introduceLayout.textBoundingSize:%@", _introduceLayout.rowCount, NSStringFromCGSize(_introduceLayout.textBoundingSize));
}

@end
