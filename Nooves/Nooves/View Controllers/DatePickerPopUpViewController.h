#import <UIKit/UIKit.h>
#import "Post.h"
@interface DatePickerPopUpViewController : UIViewController

@property (nonatomic) UIDatePicker *datepicker;
@property (nonatomic) NSMutableArray *tempPostsArray;
@property (nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lng;
@property (nonatomic) NSString *location;

@end
