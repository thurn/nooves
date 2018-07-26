#import <UIKit/UIKit.h>
#import "Post.h"
#import "DatePickerPopUpViewController.h"

@interface ComposeViewController : UIViewController

@property (nonatomic) NSMutableArray *tempPostsArray;
@property (nonatomic) Post *post;
@property (nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lng;
@property (nonatomic) NSString *location;
@property (nonatomic) UITextField *eventTitle;
@property (nonatomic) UITextView *eventDescription;
// @property (nonatomic) DatePickerPopUpViewController *datePicker;

@end
