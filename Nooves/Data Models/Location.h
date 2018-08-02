#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *userLocation;
@property (nonatomic) NSNumber *userLat;
@property (nonatomic) NSNumber *userLng;
@property (nonatomic) BOOL enabled;

+ (instancetype)currentLocation;

@end
