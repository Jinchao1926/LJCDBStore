//
//  LJCVideoHelper.h
//  LJCDBStore
//
//  Created by 林锦超 on 08/12/2017.
//  Copyright © 2017 林锦超. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LJCVideoHelper : NSObject

+ (NSString *)durationWithVideoTimeInterval:(NSTimeInterval)duration;

+ (NSString *)durationWithVideoURL:(NSURL *)videoURL;
+ (NSString *)durationWithAudioURL:(NSURL *)audioURL;
@end
