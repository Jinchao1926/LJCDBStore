//
//  LJCDoctorCell.h
//  LJCDBStore
//
//  Created by 林锦超 on 31/10/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LJCDoctorModel;
@interface LJCDoctorCell : UITableViewCell

- (void)configWithModel:(LJCDoctorModel *)model;
@end
