#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController

@property(nonatomic) NSMutableArray *usersArray;
- (void)initProfileWithUser:(User *)newUser;

@end
