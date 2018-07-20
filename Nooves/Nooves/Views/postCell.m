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

@synthesize testLabel = _testLabel;

bool going = NO;
bool interested = NO;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // set up the post field
        self.postField = [[UILabel alloc]initWithFrame:(CGRectMake(100, 0, 250, 30))];
        [self.postField setBackgroundColor:[UIColor greenColor]];
        self.postField.text = @"Insert Post here";
        [self.postField sizeToFit];
        [self.contentView addSubview:_postField];
        
       CGSize constraint = CGSizeMake(self.postField.frame.size.width, CGFLOAT_MAX);
        CGSize size;
        
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        CGSize boundingBox = [self.postField.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.postField.font} context:context].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
        CGFloat postFieldheight = size.height;
        
        
        // set up the date field
        self.dateField = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 50 , 50)];
        [self.dateField setBackgroundColor:[UIColor yellowColor]];
        [self.dateField setText:@"Date"];
        [self.dateField sizeToFit];
        [self.contentView addSubview:self.dateField];
        
        // set up the 'going' button
        self.goingButton = [[UIButton alloc] initWithFrame:CGRectMake(100, size.height+ 50, 50, 20)];
        self.goingButton.backgroundColor = [UIColor blackColor];
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
        [self.interestedButton addTarget:self action:@selector(didTapInterested) forControlEvents:UIControlEventTouchUpInside];
        

    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setPost: (Post *) post {
   
    self.post = post;
    self.postField = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 30)];
    //[self.postField setText:@"Insert Post here"];
    self.postField.text = self.post.activityDescription;
     [self.contentView addSubview:_postField];
    
   /* NSDate *time = self.post.activityDateAndTime;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"MM/DD/YYYY"];
    NSString *dateString = [df stringFromDate:time];
    self.dateField.text = dateString;*/
    
    
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
