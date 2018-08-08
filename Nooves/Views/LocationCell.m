#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LocationCell.h"
#import "PureLayout/PureLayout.h"

@interface LocationCell ()
@property (nonatomic) UILabel *addressLabel;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *categoryImageView;
@property (nonatomic) NSDictionary *location;
@end

@implementation LocationCell

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

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initialize];
    return self;
}

// initialize cell properties
- (void)initialize {
    self.categoryImageView = [[UIImageView alloc] init];
    self.addressLabel = [[UILabel alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.location = [[NSDictionary alloc] init];
    
    CGRect frame = [self.categoryImageView frame];
    frame.size.width = 30;
    [self.categoryImageView setFrame:frame];
    self.categoryImageView.frame = CGRectMake(7, 7, 30, 30);
    
    self.nameLabel.center = CGPointMake(20, 55);
    self.nameLabel.text = @"name";
    [self.nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel autoPinEdgeToSuperviewMargin:ALEdgeTop];
    [self.nameLabel autoPinEdgeToSuperviewMargin:ALEdgeLeft];
    [self.nameLabel sizeToFit];
    
    self.addressLabel.center = CGPointMake(7, 70);
    self.addressLabel.text = @"address";
    [self.addressLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    [self.contentView addSubview:self.addressLabel];
    //[self.nameLabel autoPinEdgeToSuperviewMargin:ALEdgeTop];
    //[self.nameLabel autoPinEdgeToSuperviewMargin:ALEdgeRight];
    [self.addressLabel sizeToFit];
    
    [self addSubview:self.categoryImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.addressLabel];
}

- (void)updateWithLocation:(NSDictionary *)location {
    self.nameLabel.text = location[@"name"];
    self.addressLabel.text = [location valueForKeyPath:@"location.address"];
    
    NSArray *categories = location[@"categories"];
    if (categories && categories.count > 0) {
        NSDictionary *category = categories[0];
        NSString *urlPrefix = [category valueForKeyPath:@"icon.prefix"];
        NSString *urlSuffix = [category valueForKeyPath:@"icon.suffix"];
        NSString *urlString = [NSString stringWithFormat:@"%@bg_32%@", urlPrefix, urlSuffix];
        
        NSURL *url = [NSURL URLWithString:urlString];
        [self.categoryImageView setImageWithURL:url];
    }
}

@end
