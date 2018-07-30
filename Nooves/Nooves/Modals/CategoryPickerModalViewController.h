#import <UIKit/UIKit.h>
#import "Post.h"

@class CategoryPickerModalViewController;

@protocol CategoryPickerDelegate

- (void)categoryPickerModalViewController:(CategoryPickerModalViewController *)controller
              didPickActivityType:(ActivityType *)activity;

@end

@interface CategoryPickerModalViewController : UIViewController

@property (weak, nonatomic) id<CategoryPickerDelegate>categoryDelegate;

@property (nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lng;
@property (nonatomic) NSString *location;

@end
