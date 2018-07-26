//
//  User.h
//  Nooves
//
//  Created by Norette Ingabire on 7/25/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface User : NSObject

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *biography;
@property(strong, nonatomic) UIImage *profilePic;
- (instancetype)initProfileWithInfo: (NSString *)userName withBio: (NSString *)bio;


@end
