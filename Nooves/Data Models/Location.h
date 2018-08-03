#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *userLocation;
@property (nonatomic) NSNumber *userLat;
@property (nonatomic) NSNumber *userLng;
@property (nonatomic) NSNumber *eventLat;
@property (nonatomic) NSNumber *eventLng;
@property (nonatomic) CLLocationDistance *distance;

+ (instancetype)currentLocation;

@end
