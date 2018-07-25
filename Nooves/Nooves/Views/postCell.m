//
//  postCell.m
//  Nooves
//
//  Created by Norette Ingabire on 7/16/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "postCell.h"
#import "Post.h"
#import "PureLayout/PureLayout.h"

@implementation postCell

bool going = NO;
bool interested = NO;

/* - (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

        // set up the 'going' button
        self.goingButton = [[UIButton alloc] initWithFrame:CGRectMake(100, size.height+ 50, 5 20)];
      self.goingButton.backgroundColor = [UIColor blackColor];
        [self.goingButton setTitle:@"Going" forState:UIControlStateNormal];
        [self.goingButton sizeToFit];
        [self.contentView addSubview:self.goingButton];
        [self.goingButton addTarget:self action:@selector(didTapGoing) forControlEvents:UIControlEventTouchUpInside];
        
        // set up the 'interested' button
        self.interestedButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 0, 20, 10)];
        [self.interestedButton setBackgroundColor:[UIColor blackColor]];
        [self.interestedButton setTitle:@"Interested" forState:UIControlStateNormal];
        [self.interestedButton sizeToFit];
        [self.contentView addSubview:self.interestedButton];
        [self.interestedButton addTarget:self action:@selector(didTapInterested) forControlEvents:UIControlEventTouchUpInside];

    return self;
}*/

- (void) awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) configurePost: (Post *) post {
    
    // set up the date field
    self.dateField = [[UILabel alloc]init];
    self.dateField.hidden = NO;
    [self.dateField setText:@"Date"];
    [self.dateField sizeToFit];
    [self.contentView addSubview:self.dateField];
    [self.dateField autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    [self.dateField autoPinEdgeToSuperviewMargin:ALEdgeTop];
    
    //self up the event title field
    self.eventTitleField = [[UILabel alloc]init];
    self.eventTitleField.hidden = NO;
    self.eventTitleField.text = @"Event Title";
    [self.eventTitleField sizeToFit];
    [self.contentView addSubview:self.eventTitleField];
    [self.eventTitleField autoPinEdgeToSuperviewMargin:ALEdgeTop];
    [self.eventTitleField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dateField withOffset:15.0f];
    
    // set up the activity description field
    self.activityDescriptionField = [[UILabel alloc]init];
    self.activityDescriptionField.hidden = NO;
    self.activityDescriptionField.text = @"Activity description";
    [self.activityDescriptionField sizeToFit];
    [self.contentView addSubview:self.activityDescriptionField];
    [self.activityDescriptionField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.eventTitleField withOffset:10.0f];
    [self.activityDescriptionField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.dateField withOffset:5.0f];
    [self.activityDescriptionField autoPinEdgeToSuperviewMargin:ALEdgeBottom];
    
    // set up activityType
    self.activityTypeField = [[UILabel alloc]init];
    self.activityTypeField.hidden = NO;
    self.activityTypeField.text = @"Activity type";
    [self.activityTypeField sizeToFit];
    [self.contentView addSubview:self.activityTypeField];
    [self.activityTypeField autoPinEdgeToSuperviewMargin:ALEdgeTop];
    [self.activityTypeField autoPinEdgeToSuperviewMargin:ALEdgeRight];
    
    self.post = post;
    self.activityDescriptionField.text = post.activityDescription;
    self.activityTypeField.text = [Post activityTypeToString:post.activityType];
    self.eventTitleField.text = post.activityTitle;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString = [formatter stringFromDate:post.activityDateAndTime];
    self.dateField.text = dateString;
}

- (void) didTapGoing {
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

- (void) didTapInterested {
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

- (UIButton *) goToProfile {
    self.profileButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 140, 100, 10)];
    [self.profileButton setImage:[UIImage imageNamed:@"profile_tab.png"] forState:UIControlStateNormal];
    [self.profileButton sizeToFit];
    [self.contentView addSubview:self.profileButton];
    
    [self.profileButton addTarget:self action:@selector(didTapProfile) forControlEvents:UIControlEventTouchUpInside];
    return self.profileButton;
}

-(void) didTapProfile {
    NSLog(@"did tap on profile");
}

@end
