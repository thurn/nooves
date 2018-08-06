#import <UIKit/UIKit.h>
#import "FilterViewController.h"
#import "PostCell.h"
// TODO: change timeline view controller to be a table view controller
@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, FilterViewDelegate, PostCellDelegate>

@property (strong, nonatomic) NSArray *firArray;

@end
