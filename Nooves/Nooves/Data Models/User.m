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
    self = [super init];
    if(self){
        self.name = userName;
        self.biography = bio;
    }
    return self;
}

@end
