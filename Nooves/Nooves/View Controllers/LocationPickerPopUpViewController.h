#import <CoreLocation/CoreLocation.h>
#import "Post.h"
#import <UIKit/UIKit.h>

@class LocationPickerPopUpViewController;

@protocol LocationPickerPopUpViewControllerDelegate

- (void)locationsPickerPopUpViewController:(LocationPickerPopUpViewController *)controller
               didPickLocationWithLatitude:(NSNumber *)latitude
                                 longitude:(NSNumber *)longitude;

@end

@interface LocationPickerPopUpViewController : UIViewController <LocationPickerPopUpViewControllerDelegate>

@property (weak, nonatomic) id<LocationPickerPopUpViewControllerDelegate> delegate;

@property (nonatomic) NSMutableArray *tempPostsArray;
@property (nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;
@property (nonatomic) NSNumber *lat;
@property (nonatomic) NSNumber *lng;

@end
