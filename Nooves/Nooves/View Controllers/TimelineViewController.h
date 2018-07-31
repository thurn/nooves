#import <UIKit/UIKit.h>

@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *tempPostsArray;
@property (strong, nonatomic) NSArray *postsArray;
@property (strong, nonatomic) NSArray *firArray;
@end
