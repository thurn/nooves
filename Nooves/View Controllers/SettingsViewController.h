#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsDelegate

- (void)settingsViewController:(SettingsViewController *)settingsController didSelectCity:(NSString *)city state:(NSString *)state;

@end

@interface SettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<SettingsDelegate>settingsDelegate;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;

@end
