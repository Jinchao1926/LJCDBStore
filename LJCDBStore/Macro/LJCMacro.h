//
//  LJCMacro.h
//  LJCDBStore
//
//  Created by 林锦超 on 27/11/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#ifndef LJCMacro_h
#define LJCMacro_h

#define     kDeviceIPhoneX      (kStatusHeight != 20)
/**< 尺寸 */
#pragma mark - Size
#define     kStatusHeight       [UIApplication sharedApplication].statusBarFrame.size.height
#define     kUnsafeBottomHeight (kDeviceIPhoneX ? 34.f : 0.f)
#define     kTabbarHeight       kUnsafeBottomHeight + 49.f    //49.f or 83.f in X
#define     kNavBarHeight       44.0f
#define     kNavStatusBarHeight (kStatusHeight + kNavBarHeight)

#endif /* LJCMacro_h */
