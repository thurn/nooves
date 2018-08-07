//
//  UIImageView+Cache.m
//  Nooves
//
//  Created by Nkenna Aniedobe on 8/7/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "UIImageView+Cache.h"

@implementation UIImageView (Cache)
- (void)setMyCache:(NSCache *)myCache{
}
- (NSCache *)myCache{
    return [[NSCache alloc] init];
}
- (void) loadURLandCache:(NSString *)string{
    if(!self.myCache){
        self.myCache = [[NSCache alloc] init];
    }
    if([self.myCache objectForKey:string]){
        self.image = [self.myCache objectForKey:string];
        return;
    }
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:string] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(error){
                NSLog(@"%@", error);
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *myImage = [UIImage imageWithData:data];
                if(myImage){
                    [self.myCache setObject:myImage forKey:string];
                    self.image = myImage;
                }
            });
        }];
        [task resume];
}
@end
