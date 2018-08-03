#import <UIKit/UIKit.h>

// TODO(Nikki): change timeline view controller to be a table view controller
@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *firArray;

@end
