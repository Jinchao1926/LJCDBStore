//
//  LJCPhotoBrowserProxy.h
//  LJCDBStore
//
//  Created by 林锦超 on 11/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"
#import "MWPhoto+LJCExtension.h"

typedef NS_ENUM(NSInteger, LJCPhotoBrowserProxyType)
{
    LJCPhotoBrowserProxyChat,
};

typedef void(^LJCPhotoBrowserProxyDidDismissHandler)(void);
@interface LJCPhotoBrowserProxy : NSObject<MWPhotoBrowserDelegate>

@property (nonatomic, assign) LJCPhotoBrowserProxyType proxyType;
@property (nonatomic, strong) NSMutableArray<MWPhoto *> *photos;
@property (nonatomic, copy) LJCPhotoBrowserProxyDidDismissHandler dismissHandler;

- (void)presentPhotoBrowser;
- (void)presentPhotoBrowserWithIndex:(NSUInteger)index;
@end
