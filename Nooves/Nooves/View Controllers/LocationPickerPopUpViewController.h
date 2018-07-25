#import <CoreLocation/CoreLocation.h>
#import <Mapkit/Mapkit.h>
#import "Post.h"
#import <UIKit/UIKit.h>

@class LocationsPickerPopUpViewController;

@protocol LocationsPickerPopUpViewControllerDelegate

- (void)locationsPickerPopUpViewController:(LocationsPickerPopUpViewController *)controller
               didPickLocationWithLatitude:(NSNumber *)latitude
                                 longitude:(NSNumber *)longitude;

@end

@interface LocationPickerPopUpViewController : UIViewController

@property (weak, nonatomic) id<LocationsPickerPopUpViewControllerDelegate> delegate;

@property (nonatomic) NSMutableArray *tempPostsArray;
@property (nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;

@end
