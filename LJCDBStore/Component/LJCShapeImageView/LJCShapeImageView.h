//
//  LJCShapeImageView.h
//  LJCDBStore
//
//  Created by 林锦超 on 06/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LJCShapeImageView : UIButton
///< content image
@property (nonatomic, strong) UIImage *contentImage;
///< mask image
@property (nonatomic, strong) UIImage *maskImage;
@end
