//
//  UIImageView+Cache.h
//  Nooves
//
//  Created by Nkenna Aniedobe on 8/7/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Cache)
@property (strong, nonatomic) NSCache *myCache;
- (void) loadURLandCache:(NSString *)string;
@end
