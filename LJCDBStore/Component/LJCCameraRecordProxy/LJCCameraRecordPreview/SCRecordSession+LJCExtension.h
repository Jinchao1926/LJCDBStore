//
//  SCRecordSession+LJCExtension.h
//  LJCDBStore
//
//  Created by 林锦超 on 20/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

//#import <SCRecorder/SCRecorder.h>
#import "SCRecorder.h"

@interface SCRecordSession (LJCExtension)

- (SCRecordSessionSegment *)firstSegment;
- (SCRecordSessionSegment *)lastSegment;

- (UIImage *)thumbnail;

- (void)cancelSessionTotally:(void (^)(void))completionHandler;
@end
