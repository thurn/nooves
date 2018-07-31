#import <UIKit/UIKit.h>
#import "User.h"

@protocol editProfileDelegate
- (void)didUpdateProfile;
@end

@interface EditProfileViewController : UIViewController

@property(nonatomic, weak) id<editProfileDelegate> delegate;

@end
