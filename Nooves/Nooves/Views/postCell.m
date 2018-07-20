//
//  postCell.m
//  Nooves
//
//  Created by Norette Ingabire on 7/16/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "postCell.h"
#import "Post.h"
//#import "ProfileViewController.h"

@implementation postCell

bool going = NO;
bool interested = NO;

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

      /* CGSize constraint = CGSizeMake(self.postField.frame.size.width, CGFLOAT_MAX);
        CGSize size;
        
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        CGSize boundingBox = [self.postField.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.postField.font} context:context].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
        CGFloat postFieldheight = size.height;
        */
        
        // set up the 'going' button
//       self.goingButton = [[UIButton alloc] initWithFrame:CGRectMake(100, size.height+ 50, 5 20)];
       /* self.goingButton.backgroundColor = [UIColor blackColor];
        [self.goingButton setTitle:@"Going" forState:UIControlStateNormal];
        //[self.goingButton sizeToFit];
       // [self.contentView addSubview:self.goingButton];
        [self.goingButton addTarget:self action:@selector(didTapGoing) forControlEvents:UIControlEventTouchUpInside];
        
        // set up the 'interested' button
        self.interestedButton = [[UIButton alloc] initWithFrame:CGRectMake(290, 0, 20, 10)];
        [self.interestedButton setBackgroundColor:[UIColor blackColor]];
        [self.interestedButton setTitle:@"Interested" forState:UIControlStateNormal];
        [self.interestedButton sizeToFit];
      //  [self.contentView addSubview:self.interestedButton];
        [self.interestedButton addTarget:self action:@selector(didTapInterested) forControlEvents:UIControlEventTouchUpInside];*/
        

//    
//    return self;
//}

- (void) awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configurePost: (Post *) post {
    // set up the post field
    self.activityDescriptionField = [[UILabel alloc]initWithFrame:(CGRectMake(100, 40, 250, 30))];
    [self.activityDescriptionField setBackgroundColor:[UIColor greenColor]];
    self.activityDescriptionField.text = @"Insert Post here";
    
    [self.activityDescriptionField sizeToFit];
    [self.contentView addSubview:self.activityDescriptionField];
    
    
    //self up the event title
    
    self.eventTitle = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 50, 50)];
    [self.eventTitle setBackgroundColor:[UIColor cyanColor]];
    self.eventTitle.text = @"Event Title";
    [self.eventTitle sizeToFit];
    [self.contentView addSubview:self.eventTitle];
    
    // set up activityType
    self.activityTypeField = [[UILabel alloc] initWithFrame:CGRectMake(270, 0, 30, 30)];
    //[self.activityTypeField setBackgroundColor:[UIColor blueColor]];
    self.activityTypeField.text = @"Activity type";
    [self.activityTypeField sizeToFit];
    [self.contentView addSubview:self.activityTypeField];
    
    self.dateField = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 100 , 50)];
    [self.dateField setBackgroundColor:[UIColor yellowColor]];
    [self.dateField setText:@"Date"];
    [self.dateField sizeToFit];
    [self.contentView addSubview:self.dateField];
    
    self.post = post;
    self.activityDescriptionField.text = post.activityDescription;
    self.activityTypeField.text = [Post activityTypeToString:post.activityType];
    self.eventTitle.text = post.activityTitle;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString = [formatter stringFromDate:post.activityDateAndTime];
    self.dateField.text = dateString;
}

- (void) didTapGoing {
    //  change button color and number/list of people going and check for unselected button
    if (!interested) {
        if (going) {
            // remove the user from the list of those going
            NSLog(@"not going anymore");
            [self.goingButton setBackgroundColor:[UIColor blackColor]];
            going = NO;
        }
        
        else {
            // add the user to the list of those going
            NSLog(@"TAPPED GOING BUTTON");
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
            NSLog(@"not going anymore");
            [self.goingButton setBackgroundColor:[UIColor blackColor]];
            going = NO;
        }
        
        else {
            // add the user to the list of those going
            NSLog(@"TAPPED GOING BUTTON");
            UIColor *selectedGoing = [UIColor greenColor];
            [self.goingButton setBackgroundColor:selectedGoing];
            going = YES;
        }
    }
}

- (UIButton *) interestedInEvent {
    
    return self.interestedButton;
}

- (void) didTapInterested {
    if (!going) {
        if (interested) {
            // DECREMENT THE NUMBER OF THOSE INTERESTED - REMOVE USER FROM THE LIST
            NSLog(@"Changed to not interested");
            [self.interestedButton setBackgroundColor:[UIColor blackColor]];
            interested = NO;
        }
        else {
            // ADD THE USER TO THE LIST OF THOSE INTERESTED
            NSLog(@"tapped interested button");
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
            NSLog(@"Changed to not interested");
            [self.interestedButton setBackgroundColor:[UIColor blackColor]];
            interested = NO;
        }
        else {
            // ADD THE USER TO THE LIST OF THOSE INTERESTED
            NSLog(@"tapped interested button");
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
