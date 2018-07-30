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

+ (void)saveUserProfile:(User *)user {
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *reference = [[ref child:@"Users"]child:[FIRAuth auth].currentUser.uid];
    [reference setValue:@{@"Name":user.name,@"Age":user.age, @"Bio":user.biography, @"Phone number":user.phoneNumber}]; //@"ProfilePicURL":user.profilePicURL}];
}

+ (NSArray *)readUsersFromDatabase:(NSDictionary *)usersDict {
    NSMutableArray *usersArray = [[NSMutableArray alloc]init];
    for (NSString *userKey in usersDict) {
        User *newUser = [[User alloc]init];
        newUser.userID = userKey;
        newUser.age = usersDict[userKey][@"Age"];
        newUser.biography = usersDict[userKey][@"Bio"];
        newUser.name = usersDict[userKey][@"Name"];
        newUser.phoneNumber = usersDict[userKey][@"Phone number"];
        [usersArray addObject:newUser];
    }
    NSArray *finalArray = [NSArray arrayWithArray:usersArray];
    return finalArray;
}
@end
