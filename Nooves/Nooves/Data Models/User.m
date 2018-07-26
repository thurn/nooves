//
//  User.m
//  Nooves
//
//  Created by Norette Ingabire on 7/25/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initProfileWithInfo: (NSString *)userName withBio: (NSString *)bio {
    User *user = [[User alloc]init];
    user.name = userName;
    user.biography = bio;
    
    return user;
}

@end
