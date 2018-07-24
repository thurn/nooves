#import <AFNetworking/UIImageView+AFNetworking.h>
#import "LocationCell.h"

@interface LocationCell ()

@property (nonatomic) UILabel *addressLabel;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UIImageView *categoryImageView;
@property (nonatomic) NSDictionary *location;

@end

@implementation LocationCell

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self initialize];
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    [self initialize];
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self initialize];
    return self;
}

- (void)initialize {
    // initialize cell properties
    self.categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 200, 100, 100)];
    self.addressLabel = [[UILabel alloc] init];
    self.nameLabel = [[UILabel alloc] init];
    self.location = [[NSDictionary alloc] init];
    
    self.categoryImageView.frame = CGRectMake(0, 0, 20, 20);
    
    self.addressLabel.frame = CGRectMake(0, 30, 10, 10);
    
    self.nameLabel.frame = CGRectMake(0, 50, 10, 10);
    
    [self addSubview:self.categoryImageView];
    [self addSubview:self.addressLabel];
    [self addSubview:self.nameLabel];
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
