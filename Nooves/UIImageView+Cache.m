//
//  UIImageView+Cache.m
//  Nooves
//
//  Created by Nkenna Aniedobe on 8/7/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "UIImageView+Cache.h"
#import <SDWebImageManager.h>
#import <SDWebImageDownloader.h>
#import <SDWebImage/UIImageView+WebCache.h>
@implementation UIImageView (Cache)
- (void)setMyCache:(NSCache *)myCache{
}
- (NSCache *)myCache{
    return [[NSCache alloc] init];
}
- (void) loadURLandCache:(NSString *)string{
    [self sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"profile-blank"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            NSLog(@"%@", error);
        }
    }];
}
@end
