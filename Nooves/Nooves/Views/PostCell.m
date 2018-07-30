#import "Post.h"
#import "PostCell.h"
#import "PureLayout/PureLayout.h"

@implementation PostCell

    bool going = NO;
    bool interested = NO;

- (void) awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configurePost: (Post *) post {
    self.post = post;
    if(self.post){
        // set up the date field
        self.dateField = [[UILabel alloc]init];
        self.dateField.hidden = NO;
        [self.dateField sizeToFit];
        [self.contentView addSubview:self.dateField];
        [self.dateField autoPinEdgeToSuperviewMargin:ALEdgeLeft];
        [self.dateField autoPinEdgeToSuperviewMargin:ALEdgeTop];
        
        //self up the event title field
        self.eventTitleField = [[UILabel alloc]init];
        self.eventTitleField.hidden = NO;
        [self.eventTitleField sizeToFit];
        [self.contentView addSubview:self.eventTitleField];
        [self.eventTitleField autoPinEdgeToSuperviewMargin:ALEdgeTop];
        [self.eventTitleField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dateField withOffset:15.0f];
        
        // set up the activity description field
        self.activityDescriptionField = [[UILabel alloc]init];
        self.activityDescriptionField.hidden = NO;
        [self.activityDescriptionField sizeToFit];
        [self.contentView addSubview:self.activityDescriptionField];
        [self.activityDescriptionField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.eventTitleField withOffset:10.0f];
        [self.activityDescriptionField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dateField withOffset:5.0f];
        [self.activityDescriptionField autoPinEdgeToSuperviewMargin:ALEdgeBottom];
        
        // set up activityType
        self.activityTypeField = [[UILabel alloc]init];
        self.activityTypeField.hidden = NO;
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
}

- (void)didTapGoing {
    //  change button color and number/list of people going
    
    if (!interested) {
        if (going) {
            // remove the user from the list of those going
            [self.goingButton setBackgroundColor:[UIColor blackColor]];
            going = NO;
        }
        
        else {
            // add the user to the list of those going
            UIColor *selectedGoing = [UIColor greenColor];
            [self.goingButton setBackgroundColor:selectedGoing];
            going = YES;
        }
    }
    
    else {
        interested = NO;
        [self.interestedButton setBackgroundColor:[UIColor blackColor]];
        if (going) {
            // remove the user from the list of those going
            [self.goingButton setBackgroundColor:[UIColor blackColor]];
            going = NO;
        }
        
        else {
            // add the user to the list of those going
            UIColor *selectedGoing = [UIColor greenColor];
            [self.goingButton setBackgroundColor:selectedGoing];
            going = YES;
        }
    }
}

- (void)didTapInterested {
    if (!going) {
        if (interested) {
            // DECREMENT THE NUMBER OF THOSE INTERESTED - REMOVE USER FROM THE LIST
            [self.interestedButton setBackgroundColor:[UIColor blackColor]];
            interested = NO;
        }
        else {
            // ADD THE USER TO THE LIST OF THOSE INTERESTED
            UIColor *selectedInterested = [UIColor greenColor];
            [self.interestedButton setBackgroundColor:selectedInterested];
            interested = YES;
        }
    }
    
    else {
        going = NO;
        [self.goingButton setBackgroundColor:[UIColor blackColor]];
        if (interested) {
            // DECREMENT THE NUMBER OF THOSE INTERESTED - REMOVE USER FROM THE LIST
            [self.interestedButton setBackgroundColor:[UIColor blackColor]];
            interested = NO;
        }
        else {
            // ADD THE USER TO THE LIST OF THOSE INTERESTED
            UIColor *selectedInterested = [UIColor greenColor];
            [self.interestedButton setBackgroundColor:selectedInterested];
            interested = YES;
        }
    }
}

- (UIButton *)goToProfile {
    self.profileButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 140, 100, 10)];
    [self.profileButton setImage:[UIImage imageNamed:@"profile_tab.png"] forState:UIControlStateNormal];
    [self.profileButton sizeToFit];
    [self.contentView addSubview:self.profileButton];
    
    [self.profileButton addTarget:self action:@selector(didTapProfile) forControlEvents:UIControlEventTouchUpInside];
    return self.profileButton;
}

-(void)didTapProfile {
    NSLog(@"did tap on profile");
}

@end
