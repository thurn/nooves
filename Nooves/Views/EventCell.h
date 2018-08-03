#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventCell : UITableViewCell

//@property(strong, nonatomic) Event *event;

- (void)updateWithEvent:(NSDictionary *)dictionary;


@end
