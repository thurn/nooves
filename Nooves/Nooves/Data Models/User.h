//
//  User.h
//  Nooves
//
//  Created by Norette Ingabire on 7/25/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FirebaseStorage.h>
#import <FirebaseDatabase.h>
#import <FirebaseAuth.h>

@interface User : NSObject

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *biography;
@property(strong, nonatomic) NSNumber *age;
@property(strong, nonatomic) NSNumber *phoneNumber;
@property(strong, nonatomic) UIImage *profilePic;
@property(strong, nonatomic) NSString *profilePicURL;
@property(strong, nonatomic) NSString *userID;


- (void)addToProfileWithInfo: (NSString *)userName
                     withBio: (NSString *)bio
                     withAge: (NSNumber *)age
                  withNumber: (NSNumber *)number;


+ (void) saveUserProfile:(User *)user;
+ (NSArray *)readUsersFromDatabase:(NSDictionary *)usersDict;

@end
