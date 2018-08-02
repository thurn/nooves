#import <AFNetworking.h>
#import "Event.h"
#import "EventCell.h"
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
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self configureCell];
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self configureCell];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self configureCell];
    return self;
}

- (void)configureCell {
    
    //initialize event cell properties
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,100, 20)];
    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 250, 100)];
    self.venueLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 350, 50, 50)];
    self.venueAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 350, 50, 50)];
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 350, 50, 50)];
    
    self.titleLabel.text = @"Title";
    self.descriptionLabel.text = @"Description";
    self.venueLabel.text = @"Venue Name";
    self.venueAddressLabel.text = @"Venue Address";
    self.timeLabel.text = @"Time";
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.descriptionLabel];
    [self addSubview:self.venueLabel];
    [self addSubview:self.venueAddressLabel];
    [self addSubview:self.timeLabel];
}

@end
