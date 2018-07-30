#import "User.h"


@implementation User


- (void)addToProfileWithInfo: (NSString *)userName
                            withBio: (NSString *)bio
                            withAge: (NSNumber *)age
                          withNumber: (NSNumber *)number {
        self.name = userName;
        self.biography = bio;
        self.age = age;
        self.phoneNumber = number;
}

+ (void) saveUserProfile:(User *)user {
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *reference = [[ref child:@"Users"]child:[FIRAuth auth].currentUser.uid];
    [reference setValue:@{@"Name":user.name,@"Age":user.age, @"Bio":user.biography, @"Phone number":user.phoneNumber, @"ProfilePicURL":user.profilePicURL}];
}

@end
