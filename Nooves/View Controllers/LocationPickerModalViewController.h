#import <UIKit/UIKit.h>

#import "Post.h"

@class LocationPickerModalViewController;

// A protocol implemented by Compose View to store the user's selected location for an event
@protocol LocationPickerDelegate

- (void)locationsPickerModalViewController:(LocationPickerModalViewController *)controller
               didPickLocationWithLatitude:(NSNumber *)latitude
                                 longitude:(NSNumber *)longitude
                                  location:(NSString *)location;

@end

@interface LocationPickerModalViewController : UIViewController

@property (weak, nonatomic) id<LocationPickerDelegate> locationDelegate;

@end
