#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;

@end
