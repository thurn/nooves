#import <UIKit/UIKit.h>

#import "Post.h"

@class DatePickerModalViewController;

 // A protocol implemented by Compose View to store the user's selected date for an event
@protocol DatePickerDelegate

- (void)datePickerModalViewController:(DatePickerModalViewController *)dateController
                          didPickDate:(NSDate *)date;

@end

@interface DatePickerModalViewController : UIViewController

@property (nonatomic, weak) id<DatePickerDelegate> dateDelegate;

@property (nonatomic) NSDate *selectedDate;

@end
