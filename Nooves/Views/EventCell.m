#import "EventCell.h"
#import "PureLayout/PureLayout.h"
#import <Masonry.h>

@interface EventCell ()


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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.titleLabel setNumberOfLines:0];
        make.top.equalTo(self.contentView.mas_top).with.offset(1);
        make.left.equalTo(self.contentView.mas_left).with.offset(10);
        make.right.equalTo(self.contentView.mas_right).with.offset(3);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-130);
    }];
    
    self.descriptionLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.descriptionLabel];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [self.descriptionLabel setNumberOfLines:0];
        make.top.equalTo(self.contentView.mas_bottom).with.offset(-130);
        make.left.equalTo(self.contentView.mas_left).with.offset(3);
        make.right.equalTo(self.contentView.mas_right).with.offset(3);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-30);
    }];
    
    self.venueLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.venueLabel];
    [self.venueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_bottom).with.offset(-30);
        make.left.lessThanOrEqualTo(self.contentView.mas_left).with.offset(10);
        make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).with.offset(-5);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel autoPinEdgeToSuperviewMargin:ALEdgeBottom];
    [self.timeLabel autoPinEdgeToSuperviewMargin:ALEdgeRight];
    
    [self.contentView sizeToFit];
}

- (void)updateWithEvent:(NSDictionary *)dictionary {
    self.titleLabel.text = dictionary[@"title"];
    NSString *descriptionText = dictionary[@"description"];
  
    if([descriptionText isKindOfClass:[NSString class]]) {
        self.descriptionLabel.text = descriptionText;
       [self.descriptionLabel sizeToFit];
    }
    
    else {
        self.descriptionLabel.text = @"No description available for this event";
        [self.descriptionLabel sizeToFit];
    }
    
    NSString *location = @"Venue: ";
    self.venueLabel.text = [location stringByAppendingString:dictionary[@"venue_name"]];
    
    NSDate *date = dictionary[@"start_time"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    //[formatter setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *dateString = [formatter stringFromDate:date];
    self.timeLabel.text = dateString;
}

@end
