#import <UIKit/UIKit.h>

@class EventsViewController;

@protocol EventsSearchDelegate

- (void)eventsViewController:(EventsViewController *)controller
     didSelectEventWithTitle:(NSString *)title
             withDescription:(NSString *)description
                   withVenue:(NSString *)venue;

@end


@interface EventsViewController : UIViewController

@property (weak, nonatomic) id<EventsSearchDelegate> eventsDelegate;

@property(strong, nonatomic) NSArray *results;
- (void)fetchEventsWithQuery:(NSString *)query;
@end
