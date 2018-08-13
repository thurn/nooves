#import <UIKit/UIKit.h>

@class EventsViewController;

@protocol EventsSearchDelegate

- (void)eventsViewController:(EventsViewController *)controller
     didSelectEventWithTitle:(NSString *)title
             withDescription:(NSString *)description
                   withVenue:(NSString *)venue
                    withTime:(NSString *)time
                withLatitude:(NSNumber *)latitude
               withLongitude:(NSNumber *)longitude;

@end

@interface EventsViewController : UIViewController

@property (weak, nonatomic) id<EventsSearchDelegate> eventsDelegate;

- (void)fetchEventsWithQuery:(NSString *)query;
@end
