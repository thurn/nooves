#import <CoreLocation/CoreLocation.h>
#import "Post.h"
#import <UIKit/UIKit.h>

@class LocationPickerModalViewController;

@protocol LocationPickerPopUpViewControllerDelegate

- (void)locationsPickerPopUpViewController:(LocationPickerModalViewController *)controller
               didPickLocationWithLatitude:(NSNumber *)latitude
                                 longitude:(NSNumber *)longitude
                                  location:(NSString *)location;

@end

@interface LocationPickerModalViewController : UIViewController <LocationPickerPopUpViewControllerDelegate>

@property (weak, nonatomic) id<LocationPickerPopUpViewControllerDelegate> delegate;

@property (nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lng;
@property (nonatomic) NSString *location;

@end
