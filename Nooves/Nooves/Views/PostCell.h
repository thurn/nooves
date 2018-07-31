#import <UIKit/UIKit.h>
#import "Post.h"

@interface PostCell : UITableViewCell

@property (strong, nonatomic) Post *post;

@property (strong, nonatomic) UIButton *goingButton;
@property (strong, nonatomic) UIButton *interestedButton;
@property (strong, nonatomic) UIButton *profileButton;
@property (strong, nonatomic) UILabel *activityDescriptionField;
@property (strong, nonatomic) UILabel *dateField;
@property (strong, nonatomic) UILabel *eventTitleField;
@property (strong, nonatomic) UILabel *activityTypeField;


-(void) configurePost: (Post *) post;
- (UIButton *) goToProfile;

@end
