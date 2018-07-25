#import <UIKit/UIKit.h>
#import "Post.h"
#import "FirebasePost.h"

@interface CategoryPickerPopUpViewController : UIViewController

@property (nonatomic) NSMutableArray *tempPostsArray;
@property (nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lng;

@end
