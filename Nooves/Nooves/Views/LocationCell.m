#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LocationCell.h"

@interface LocationCell ()

@property (nonatomic) UILabel *addressLabel;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *categoryImageView;
@property (nonatomic) NSDictionary *location;

@end

@implementation LocationCell

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    
    // self = [super initWithStyle:nil reuseIdentifier:@"LocationCell"];
    if (self) {
        // configure control(s)
        self.categoryImageView = [[UIImageView alloc] init];
        self.addressLabel = [[UILabel alloc] init];
        self.nameLabel = [[UILabel alloc] init];
        self.location = [[NSDictionary alloc] init];
        
        [self addSubview:self.categoryImageView];
        [self addSubview:self.addressLabel];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
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
