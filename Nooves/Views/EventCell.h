#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UILabel *descriptionLabel;
@property(strong, nonatomic) UILabel *venueLabel;
@property(strong, nonatomic) UILabel *timeLabel;
@property(strong, nonatomic) UIButton *arrow;
@property(strong, nonatomic) UIButton *confirmButton;


- (void)updateWithEvent:(NSDictionary *)dictionary;
- (void)initialize;

@end
