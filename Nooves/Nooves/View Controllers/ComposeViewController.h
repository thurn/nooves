#import <UIKit/UIKit.h>
#import "Post.h"
#import "DatePickerModalViewController.h"

@interface ComposeViewController : UIViewController

@property (nonatomic) Post *post;
@property (nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lng;
@property (nonatomic) NSString *location;
@property (nonatomic) UITextField *eventTitle;
@property (nonatomic) UITextView *eventDescription;

@end
