#import <UIKit/UIKit.h>
#import "FilterViewController.h"
// TODO(Nikki): change timeline view controller to be a table view controller
@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, FilterViewDelegate>

@property (strong, nonatomic) NSArray *firArray;

@end
