#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LocationCell.h"

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
    
    [self addSubview:[self fullView]];
}

- (UIStackView *)view {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentLeading;
    stackView.spacing = 1;
    
    self.nameLabel.text = @"name";
    [self.nameLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:14]];
    [self.nameLabel sizeToFit];
    
    self.addressLabel.text = @"address";
    [self.addressLabel setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:14]];
    [self.addressLabel sizeToFit];
    
    [stackView addArrangedSubview:self.nameLabel];
    [stackView addArrangedSubview:self.addressLabel];
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    return stackView;
}

- (UIStackView *)fullView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    stackView.alignment = UIStackViewAlignmentLeading;
    stackView.spacing = 5;
    
    stackView.frame = CGRectMake(5, 5, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.categoryImageView.frame = CGRectMake(10, 10, 40, 40);
    self.categoryImageView.clipsToBounds = YES;
    self.categoryImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.categoryImageView.widthAnchor constraintEqualToConstant:40].active = true;
    [self.categoryImageView.heightAnchor constraintEqualToConstant:40].active = true;
    
    [stackView addArrangedSubview:self.categoryImageView];
    [stackView addArrangedSubview:[self view]];
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    return stackView;
}

- (void)updateWithLocation:(NSDictionary *)location {
    self.nameLabel.text = location[@"name"];
    self.addressLabel.text = [location valueForKeyPath:@"location.address"];
    [self.nameLabel sizeToFit];
    [self.addressLabel sizeToFit];
    
    if (![self.nameLabel isEqual:@""] && ![self.addressLabel isEqual:@""]) {
        self.nameLabel.hidden = NO;
        self.addressLabel.hidden = NO;
    }
    
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
