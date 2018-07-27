//
//  User.m
//  Nooves
//
//  Created by Norette Ingabire on 7/25/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "User.h"


@implementation User


- (instancetype)initProfileWithInfo: (NSString *)userName
                            withBio: (NSString *)bio
                            withAge: (NSNumber *)age
                         withNumber: (NSNumber *)number{
    self = [super init];
    if(self){
        self.name = userName;
        self.biography = bio;
        self.age = age;
        self.phoneNumber = number;
    }
    return self;
}

+ (void) saveUserProfile:(User *)user {
    //FIRStorageReference *storageRef = [[FIRStorage storage]reference];
    
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *reference = [[ref child:@"Users"]child:[FIRAuth auth].currentUser.uid];
    [reference setValue:@{@"Name":user.name,@"Age":user.age, @"Bio":user.biography, @"Phone number":user.phoneNumber}];
}

@end
