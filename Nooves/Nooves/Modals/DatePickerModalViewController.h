#import <UIKit/UIKit.h>
#import "Post.h"
@interface DatePickerModalViewController : UIViewController

@property (nonatomic) UIDatePicker *datepicker;
@property (nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lng;
@property (nonatomic) NSString *location;
@property (nonatomic) UITextField *eventTitle;
@property (nonatomic) UITextView *eventDescription;

@end