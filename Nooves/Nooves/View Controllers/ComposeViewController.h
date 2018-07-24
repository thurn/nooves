#import <UIKit/UIKit.h>
#import "Post.h"
@interface ComposeViewController : UIViewController

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *eventNameLabel;
@property (strong, nonatomic) UITextField *eventTitle;
@property (strong, nonatomic) UITextView *eventDescription;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *tempPostsArray;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;

@end
