#import <UIKit/UIKit.h>
#import "Post.h"

@class DatePickerModalViewController;

@protocol DatePickerDelegate

- (void)datePickerModalViewController:(DatePickerModalViewController *)dateController
                          didPickDate:(NSDate *)date;

@end

@interface DatePickerModalViewController : UIViewController

@property (nonatomic, weak) id<DatePickerDelegate>dateDelegate;
@property (nonatomic) ActivityType activityType;
@property (nonatomic) UIDatePicker *datepicker;
@property (nonatomic) UITextField *eventTitle;
@property (nonatomic) UITextView *eventDescription;

@end
