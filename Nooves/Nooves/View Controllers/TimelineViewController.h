#import <UIKit/UIKit.h>
#import "Post.h"
@class TimelineViewController;


@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (strong, nonatomic) NSArray *firArray;
@end
