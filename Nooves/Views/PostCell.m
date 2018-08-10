
#import "PostCell.h"
#import "PureLayout/PureLayout.h"
#import <FIRDatabase.h>
#import "Post.h"
#import "UIImageView+Cache.h"
#import <Masonry.h>

@implementation PostCell {
    BOOL constrained;
};
- (void) awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    constrained = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //  the view for the selected state
}

- (void)configurePost: (Post *) post {
    
    self.post = post;
    if (self.post){

        if(!self.dateField){
            self.dateField = [[UILabel alloc]init];
        }
        [self.dateField sizeToFit];
        [self.contentView addSubview:self.dateField];
        [self.dateField autoPinEdgeToSuperviewMargin:ALEdgeLeft];
        [self.dateField autoPinEdgeToSuperviewMargin:ALEdgeTop];
        if(!self.profilePicField){
            self.profilePicField = [[UIImageView alloc] initWithFrame:CGRectMake(self.dateField.frame.origin.x, self.dateField.frame.size.height+22, 70, 70)];
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
        // set up the activity description field
        if (!self.activityDescriptionField) {
            self.activityDescriptionField = [[UILabel alloc]init];
        }
        [self.activityDescriptionField sizeToFit];
        [self.contentView addSubview:self.activityDescriptionField];

        
        // set up activityType
        if (!self.activityTypeField) {
            self.activityTypeField = [[UILabel alloc]init];
        }
        [self.activityTypeField sizeToFit];
        [self.contentView addSubview:self.activityTypeField];
        self.activityDescriptionField.text = post.activityDescription;
        self.activityTypeField.text = [Post activityTypeToString:post.activityType];
        self.eventTitleField.text = post.activityTitle;
        [self.activityTypeField sizeToFit];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MMM dd hh:mm a"];
        NSString *dateString = [formatter stringFromDate:post.activityDateAndTime];
        self.dateField.text = dateString;
        [self.eventTitleField setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [self.eventTitleField sizeToFit];
        [self.contentView addSubview:self.eventTitleField];
    }
    else {
        self.activityTypeField.text = @"";
        self.dateField.text = @"";
        self.eventTitleField.text = @"";
        self.activityDescriptionField.text = @"";
        self.profilePicField.image = nil;
    }
    if(constrained) {
        [self updateConstraints];
    }
}

- (void)didTapProfile {
    [self.postDelegate didTapProfilePic:self.post.userID];
}

- (void)updateConstraints {
        [self.dateField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
        }];
        [self.profilePicField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dateField.mas_bottom).with.offset(3);
            make.left.equalTo(self.contentView.mas_left).with.offset(20);
            make.width.equalTo(@(50));
            make.height.equalTo(@(50));
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).with.offset(-13);
        }];
        [self.eventTitleField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10).priorityHigh();
        }];
        [self.activityTypeField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
        }];
        [self.eventTitleField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.lessThanOrEqualTo(self.activityTypeField.mas_left).with.offset(-13).priorityHigh();
            make.left.greaterThanOrEqualTo(self.dateField.mas_right).with.offset(13).priorityHigh();
            CGFloat centerPos = self.activityTypeField.frame.origin.x+self.dateField.frame.origin.x+self.dateField.frame.size.width;
            make.centerX.equalTo(@(centerPos/2)).priorityHigh();
        }];
        [self.activityDescriptionField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.profilePicField.mas_right).with.offset(13);
            make.right.equalTo(self.contentView.mas_right).with.offset(-15);
            self.activityDescriptionField.numberOfLines = 2;
            make.top.equalTo(self.dateField.mas_bottom).with.offset(14);
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).with.offset(-12);
        }];
        [self.eventTitleField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.activityDescriptionField.mas_top).with.offset(-14);
        }];
        [self.profilePicField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.activityDescriptionField.mas_left).with.offset(-13);
        }];
    constrained = NO;
        [super updateConstraints];

}

@end
