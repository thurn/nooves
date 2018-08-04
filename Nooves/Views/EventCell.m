#import <AFNetworking.h>
//#import "Event.h"
#import "EventCell.h"
#import "EventsViewController.h"
#import "PureLayout/PureLayout.h"

@interface EventCell ()

@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UILabel *descriptionLabel;
@property(strong, nonatomic) UILabel *venueLabel;
@property(strong, nonatomic) UILabel *timeLabel;

@end

@implementation EventCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self initialize];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initialize];
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initialize];
    return self;
}

- (void)initialize {
    
    //initialize event cell properties
    self.titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel autoPinEdgeToSuperviewMargin:ALEdgeTop];
    [self.titleLabel autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    
    self.descriptionLabel = [[UILabel alloc]init];
     [self.contentView addSubview:self.descriptionLabel];
    [self.descriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:5.0f];
    
    self.venueLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.venueLabel];
    [self.venueLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.descriptionLabel withOffset:10.0f];
    [self.venueLabel autoPinEdgeToSuperviewMargin:ALEdgeBottom];
    
    self.timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel autoPinEdgeToSuperviewMargin:ALEdgeBottom];
    [self.timeLabel autoPinEdgeToSuperviewMargin:ALEdgeRight];
}

- (void)updateWithEvent:(NSDictionary *)dictionary {
    self.titleLabel.text = dictionary[@"title"];
    NSString *descriptionText = dictionary[@"description"];
    if ([descriptionText isEqualToString:@""]) {
        NSLog(@"the length is null");
    }
    
    else {
        NSLog(@"the length is not null");
         self.descriptionLabel.text = @"Description";
    }
   
    //self.descriptionLabel.text = dictionary[@"description"];
    self.venueLabel.text = dictionary[@"venue_name"];
    NSDate *date = dictionary[@"start_time"];
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *dateDetails = [formatter stringFromDate:date];
   // NSLog(@"Datedetails:%@", dateDetails);
    self.timeLabel.text = @"Time";
    //self.timeLabel.text = dateDetails;
}
@end
