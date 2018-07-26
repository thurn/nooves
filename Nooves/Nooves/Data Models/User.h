//
//  User.h
//  Nooves
//
//  Created by Norette Ingabire on 7/25/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *biography;
- (instancetype)initProfileWithInfo: (NSString *)userName withBio: (NSString *)bio;

@end
