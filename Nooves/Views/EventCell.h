#import <UIKit/UIKit.h>

@class EventCell;

@protocol EventCellDelegate <NSObject>

- (void)didTapConfirmEvent:(EventCell *)cell;

@end

@interface EventCell : UITableViewCell

@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UILabel *descriptionLabel;
@property(strong, nonatomic) UILabel *venueLabel;
@property(strong, nonatomic) UILabel *timeLabel;
@property(strong, nonatomic) UIButton *arrow;
@property(strong, nonatomic) UIButton *confirmButton;

@property(weak, nonatomic) id <EventCellDelegate> delegate;

- (void)updateWithEvent:(NSDictionary *)dictionary;
- (void)initialize;

@end
