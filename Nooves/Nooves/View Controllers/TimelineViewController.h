#import <UIKit/UIKit.h>

@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *tempPostsArray;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) NSArray *postsArray;
@property (strong, nonatomic) NSArray *firArray;
@end
