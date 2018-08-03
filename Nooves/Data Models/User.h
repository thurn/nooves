#import <FirebaseStorage.h>
#import <FirebaseDatabase.h>
#import <FirebaseAuth.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property(strong, nonatomic) NSString *name;
@property(strong, nonatomic) NSString *biography;
@property(strong, nonatomic) NSNumber *age;
@property(strong, nonatomic) NSNumber *phoneNumber;
@property(strong, nonatomic) UIImage *profilePic;
@property(strong, nonatomic) NSString *profilePicURL;
@property(strong, nonatomic) NSString *userID;
@property(strong, nonatomic) NSArray *eventsGoing;

- (void)addToProfileWithInfo: (NSString *)userName
                     withBio: (NSString *)bio
                     withAge: (NSNumber *)age
                  withNumber: (NSNumber *)number;


+ (void)saveUserProfile:(User *)user;
- (instancetype)initFromDatabase:(NSDictionary *)usersDict;

@end
