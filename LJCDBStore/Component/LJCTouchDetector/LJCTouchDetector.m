//
//  LJCTouchDetector.m
//  LJCDBStore
//
//  Created by 林锦超 on 18/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "LJCTouchDetector.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation LJCTouchDetector

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.enabled) {
        self.state = UIGestureRecognizerStateBegan;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.enabled) {
        self.state = UIGestureRecognizerStateEnded;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.enabled) {
        self.state = UIGestureRecognizerStateEnded;
    }
}
@end
