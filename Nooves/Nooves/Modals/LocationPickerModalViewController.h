#import <CoreLocation/CoreLocation.h>
#import "Post.h"
#import <UIKit/UIKit.h>

@class LocationPickerModalViewController;

@protocol LocationPickerDelegate

- (void)locationsPickerModalViewController:(LocationPickerModalViewController *)controller
               didPickLocationWithLatitude:(NSNumber *)latitude
                                 longitude:(NSNumber *)longitude
                                  location:(NSString *)location;

@end

@interface LocationPickerModalViewController : UIViewController

@property (weak, nonatomic) id<LocationPickerDelegate>locationDelegate;

@property (nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lng;
@property (nonatomic) NSString *location;

@end
