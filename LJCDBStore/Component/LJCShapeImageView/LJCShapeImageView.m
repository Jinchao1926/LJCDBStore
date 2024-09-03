//
//  LJCShapeImageView.m
//  LJCDBStore
//
//  Created by 林锦超 on 06/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCShapeImageView.h"

@interface LJCShapeImageView()
@property (nonatomic, assign) CAShapeLayer *maskLayer;
//@property (nonatomic, assign) CALayer *contentLayer;
@end

@implementation LJCShapeImageView

- (void)dealloc
{
    NSLog(@"delloc LJCShapeImageView");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.contentsCenter = CGRectMake(0.5, 0.6, 0.1, 0.1);      //设置拉伸点
        maskLayer.contentsScale = [UIScreen mainScreen].scale;          //设置自动拉伸的效果且不变形
        
        self.layer.mask = maskLayer;
        self.maskLayer = maskLayer;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 只适用于 UIView http://www.cocoachina.com/ios/20151113/14211.html
//    [UIView performWithoutAnimation:^{
//        self.maskLayer.frame = self.bounds;
//    }];
    
    /// 禁止 layer 的隐式动画 http://www.jianshu.com/p/7d911645c244
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.maskLayer.frame = self.bounds;
    [CATransaction commit];
}

#pragma mark - Setter
- (void)setContentImage:(UIImage *)contentImage
{
    if ([contentImage isKindOfClass:[UIImage class]]) {
        if ([_contentImage isEqual:contentImage]) {
            return;
        }
        _contentImage = contentImage;
        
        /// 重新绘制完成后才替换，类似双缓存的概念
//        CALayer *layer = [CALayer layer];
//        layer.frame = self.bounds;
//        layer.mask = self.maskLayer;
//        layer.contents = (id)(contentImage.CGImage);
//        [self.contentLayer removeFromSuperlayer];
//        [self.layer addSublayer:layer];
//        self.contentLayer = layer;
        
        self.layer.contents = (id)(contentImage.CGImage);
    }
}

- (void)setMaskImage:(UIImage *)maskImage
{
    if ([_maskImage isEqual:maskImage]) {
        return;
    }
    _maskImage = maskImage;
    
//    self.maskLayer.path = (__bridge CGPathRef _Nullable)(maskImage.accessibilityPath);
//    self.maskLayer.borderColor = [UIColor blackColor].CGColor;
//    self.maskLayer.borderWidth = 1.f;
    self.maskLayer.contents = (id)(maskImage.CGImage);
}
@end
