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
    [reference updateChildValues:@{@"Name":user.name,@"Age":user.age, @"Bio":user.biography, @"PhoneNumber":user.phoneNumber, @"ProfilePicURL":user.profilePicURL}];
}

- (instancetype)initFromDatabase:(NSDictionary *)usersDict {
    self = [super init];
    self.userID = [FIRAuth auth].currentUser.uid;
    self.age = usersDict[@"Age"];
    self.biography = usersDict[@"Bio"];
    self.name = usersDict[@"Name"];
    self.phoneNumber = usersDict[@"PhoneNumber"];
    self.profilePicURL = usersDict[@"ProfilePicURL"];
    self.eventsGoing = usersDict[@"EventsGoing"];
    return self;
}

@end
