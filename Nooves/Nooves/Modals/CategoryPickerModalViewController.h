#import <UIKit/UIKit.h>
#import "Post.h"

@class CategoryPickerModalViewController;

@protocol CategoryPickerDelegate

- (void)categoryPickerModalViewController:(CategoryPickerModalViewController *)controller
              didPickActivityType:(ActivityType *)activity;

@end

@interface CategoryPickerModalViewController : UIViewController

@property (weak, nonatomic) id<CategoryPickerDelegate>categoryDelegate;
@property (nonatomic) ActivityType activityType;

@end
