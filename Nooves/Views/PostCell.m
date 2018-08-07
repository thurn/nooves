
#import "PostCell.h"
#import "PureLayout/PureLayout.h"
#import <FIRDatabase.h>
#import "Post.h"
#import "UIImageView+Cache.h"
@implementation PostCell

- (void) awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //  the view for the selected state
}

- (void)configurePost: (Post *) post {
    self.post = post;
    if(self.post){

        if(!self.dateField){
            self.dateField = [[UILabel alloc]init];
        }
        [self.dateField sizeToFit];
        [self.contentView addSubview:self.dateField];
        [self.dateField autoPinEdgeToSuperviewMargin:ALEdgeLeft];
        [self.dateField autoPinEdgeToSuperviewMargin:ALEdgeTop];
        if(!self.profilePicField){
            self.profilePicField = [[UIImageView alloc] initWithFrame:CGRectMake(self.dateField.frame.origin.x, self.dateField.frame.size.height+22, 40, 40)];
            self.profilePicField.layer.cornerRadius = self.profilePicField.frame.size.width / 2;
            self.profilePicField.clipsToBounds = YES;
        }
        self.profilePicField.image = [UIImage imageNamed:@"profile-blank"];
        [self.contentView addSubview:self.profilePicField];
        FIRDatabaseReference *ref = [[[[FIRDatabase database] reference] child:@"Users"] child:post.userID];
        FIRDatabaseHandle *handle = [ref observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *getPic = snapshot.value;
            if(![snapshot.value isEqual:[NSNull null]]){
                if(![getPic[@"ProfilePicURL"] isEqualToString:@"nil"]){
                    [self.profilePicField loadURLandCache:getPic[@"ProfilePicURL"]];
                }
            }
        }];
        self.profilePicField.frame = CGRectMake(self.dateField.frame.origin.x, self.dateField.frame.size.height+30, 40, 40);
        self.profilePicField.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapPic = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapProfile)];
        [self.profilePicField addGestureRecognizer:tapPic];
        //self up the event title field
        if(!self.eventTitleField){
            self.eventTitleField = [[UILabel alloc]init];
        }
        [self.eventTitleField sizeToFit];
        [self.contentView addSubview:self.eventTitleField];
        [self.eventTitleField autoPinEdgeToSuperviewMargin:ALEdgeTop];
        [self.eventTitleField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dateField withOffset:15.0f];
        
        // set up the activity description field
        if (!self.activityDescriptionField) {
            self.activityDescriptionField = [[UILabel alloc]init];
        }
        [self.activityDescriptionField sizeToFit];
        [self.contentView addSubview:self.activityDescriptionField];
        [self.activityDescriptionField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.eventTitleField withOffset:10.0f];
        [self.activityDescriptionField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dateField withOffset:5.0f];
        [self.activityDescriptionField autoPinEdgeToSuperviewMargin:ALEdgeBottom];
        
        // set up activityType
        if (!self.activityTypeField) {
            self.activityTypeField = [[UILabel alloc]init];
        }
        [self.activityTypeField sizeToFit];
        [self.contentView addSubview:self.activityTypeField];
        [self.activityTypeField autoPinEdgeToSuperviewMargin:ALEdgeTop];
        [self.activityTypeField autoPinEdgeToSuperviewMargin:ALEdgeRight];
        
        self.activityDescriptionField.text = post.activityDescription;
        self.activityTypeField.text = [Post activityTypeToString:post.activityType];
        self.eventTitleField.text = post.activityTitle;
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM-dd HH:mm"];
        NSString *dateString = [formatter stringFromDate:post.activityDateAndTime];
        self.dateField.text = dateString;
    }
    else {
        self.activityTypeField.text = @"";
        self.dateField.text = @"";
        self.eventTitleField.text = @"";
        self.activityDescriptionField.text = @"";
        self.profilePicField.image = nil;
    }
}

-(void)didTapProfile {
    [self.postDelegate didTapProfilePic:self.post.userID];
}

@end
