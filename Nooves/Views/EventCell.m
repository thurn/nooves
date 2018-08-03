#import <AFNetworking.h>
#import "Event.h"
#import "EventCell.h"
#import "EventsViewController.h"
#import "PureLayout/PureLayout.h"

@interface EventCell ()

@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UILabel *descriptionLabel;
@property(strong, nonatomic) UILabel *venueLabel;
@property(strong, nonatomic) UILabel *venueAddressLabel;
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

- (void)configureEvent:(Event *)event {
    self.event = event;
    
    if (!self.event) {
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
        
        self.venueAddressLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.venueAddressLabel];
        [self.venueAddressLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.venueLabel withOffset:30.0f];
        [self.venueAddressLabel autoPinEdgeToSuperviewMargin:ALEdgeBottom];
        
        self.timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.venueAddressLabel withOffset:30.0f];
        [self.timeLabel autoPinEdgeToSuperviewMargin:ALEdgeBottom];
        [self.timeLabel autoPinEdgeToSuperviewMargin:ALEdgeRight];
        
        self.titleLabel.text = @"Title";
        [self.titleLabel sizeToFit];
        self.descriptionLabel.text = @"Description";
        [self.descriptionLabel sizeToFit];
        self.venueLabel.text = @"Venue Name";
        [self.venueLabel sizeToFit];
        self.venueAddressLabel.text = @"Venue Address";
        [self.venueAddressLabel sizeToFit];
        self.timeLabel.text = @"Time";
        
        EventsViewController *testing = [[EventsViewController alloc]init];
        [testing fetchEventsWithQuery:@"california"];
       
    }
    
    NSLog(@"event cell self is not true");
}

@end
