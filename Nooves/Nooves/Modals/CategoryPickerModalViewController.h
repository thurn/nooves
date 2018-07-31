#import <UIKit/UIKit.h>
#import "Post.h"

@class CategoryPickerModalViewController;

// A protocol implemented by Compose View to store the user's selected activity type for an event
@protocol CategoryPickerDelegate

- (void)categoryPickerModalViewController:(CategoryPickerModalViewController *)controller
                      didPickActivityType:(ActivityType *)activity;

@end

@interface CategoryPickerModalViewController : UIViewController

@property (weak, nonatomic) id<CategoryPickerDelegate> categoryDelegate;

@property (nonatomic) ActivityType activityType;

@end
