#import <UIKit/UIKit.h>

@class EventDetailsViewController;

/*@protocol LocalEventsDelegate

- (void)eventDetailsViewController:(EventDetailsViewController *)controller
     didSelectEventWithTitle:(NSString *)title
             withDescription:(NSString *)description
                   withVenue:(NSString *)venue;

@end*/


@interface EventDetailsViewController : UIViewController

@property(strong, nonatomic) NSDictionary *event;
//@property(weak, nonatomic) id<LocalEventsDelegate> locEventsDelegate;

@end
