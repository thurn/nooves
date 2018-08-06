#import <UIKit/UIKit.h>
#import "Post.h"
@class PostCell;
@protocol PostCellDelegate
- (void)didTapProfilePic:(NSString *)userID; 
@end
@interface PostCell : UITableViewCell

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) id<PostCellDelegate> postDelegate;
@property (strong, nonatomic) UIButton *goingButton;
@property (strong, nonatomic) UIButton *interestedButton;
@property (strong, nonatomic) UIButton *profileButton;
@property (strong, nonatomic) UILabel *activityDescriptionField;
@property (strong, nonatomic) UILabel *dateField;
@property (strong, nonatomic) UILabel *eventTitleField;
@property (strong, nonatomic) UILabel *activityTypeField;
@property (strong, nonatomic) UIImageView *profilePicField;
@property (strong, nonatomic) UINavigationController *navControl;

-(void) configurePost: (Post *) post;

@end
