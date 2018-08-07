#import "EventCell.h"
#import "PureLayout/PureLayout.h"

@interface EventCell ()

@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UILabel *descriptionLabel;
@property(strong, nonatomic) UILabel *venueLabel;
@property(strong, nonatomic) UILabel *timeLabel;

@end

@implementation EventCell

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
    [self.titleLabel setFont:[UIFont fontWithName:@"Arial-Boldmt" size:16]];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel autoPinEdgeToSuperviewMargin:ALEdgeTop];
    [self.titleLabel autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    
    self.descriptionLabel = [[UILabel alloc]init];
     [self.contentView addSubview:self.descriptionLabel];
    [self.descriptionLabel setNumberOfLines:0];
    [self.descriptionLabel sizeToFit];
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
    
    if([descriptionText isKindOfClass:[NSString class]]) {
        self.descriptionLabel.text = descriptionText;
        [self.descriptionLabel setNumberOfLines:0];
    }
    
    else {
        self.descriptionLabel.text = @"No description available for this event";
    }
    
    NSString *location = @"Venue: ";
    self.venueLabel.text = [location stringByAppendingString:dictionary[@"venue_name"]];
    
    NSDate *date = dictionary[@"start_time"];
    NSLog(@"Original date: %@", date);
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"Datedetails:%@", dateString);
    self.timeLabel.text = dateString;
}

@end
