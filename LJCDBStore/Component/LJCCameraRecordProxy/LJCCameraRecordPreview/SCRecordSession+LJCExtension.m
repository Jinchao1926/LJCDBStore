//
//  SCRecordSession+LJCExtension.m
//  LJCDBStore
//
//  Created by 林锦超 on 20/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import "SCRecordSession+LJCExtension.h"

@implementation SCRecordSession (LJCExtension)

- (SCRecordSessionSegment *)firstSegment
{
    if (self.segments.count > 0) {
        id segment = [self.segments firstObject];
        if ([segment isKindOfClass:[SCRecordSessionSegment class]]) {
            return segment;
        }
    }
    return nil;
}

- (SCRecordSessionSegment *)lastSegment
{
    if (self.segments.count > 0) {
        id segment = [self.segments lastObject];
        if ([segment isKindOfClass:[SCRecordSessionSegment class]]) {
            return segment;
        }
    }
    return nil;
}

- (UIImage *)thumbnail
{
    return self.firstSegment.thumbnail;
}

// cancelSession 只能删除正常的 xxx-SCVideo.0.mov, .1.mov, ...
// 会遗留一个编号最大，zero byte 的文件
- (void)cancelSessionTotally:(void (^)(void))completionHandler
{
    if (self.lastSegment) {
        NSURL *segmentDirectory = [self.lastSegment.url URLByDeletingLastPathComponent];
        NSString *segmentExt = [self.lastSegment.url.absoluteString pathExtension]; //.mov
        NSString *lastSegmentName = [[self.lastSegment.url.absoluteString lastPathComponent] stringByDeletingPathExtension];    //xxx-SCVideo.0
        
        /// dot
        NSRange dotRange = [lastSegmentName rangeOfString:@"." options:NSBackwardsSearch];
        if (dotRange.location != NSNotFound && dotRange.length > 0) {
            /// index
            NSRange indexRange = NSMakeRange(dotRange.location + dotRange.length, 1);
            if (indexRange.location + indexRange.length <= lastSegmentName.length) {
                NSString *commonName = [lastSegmentName substringToIndex:indexRange.location];  //xxx-SCVideo.
                NSString *lastSegmentIndex = [lastSegmentName substringWithRange:indexRange];
                
                // zero byte segment
                NSString *zeroByteSegmentName = [commonName stringByAppendingFormat:@"%zd", lastSegmentIndex.integerValue + 1];
                NSString *zeroByteSegmentFullName = [zeroByteSegmentName stringByAppendingPathExtension:segmentExt];
                NSURL *zeroByteSegmentURL = [segmentDirectory URLByAppendingPathComponent:zeroByteSegmentFullName];
                [[NSFileManager defaultManager] removeItemAtURL:zeroByteSegmentURL error:nil];
            }
        }
    }
    
    [self cancelSession:completionHandler];
}
@end
