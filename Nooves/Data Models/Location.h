#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *userLocation;
@property (nonatomic) NSNumber *userLat;
@property (nonatomic) NSNumber *userLng;
@property (nonatomic) NSNumber *eventLat;
@property (nonatomic) NSNumber *eventLng;
@property (nonatomic) CLLocationDistance *distance;
@property (nonatomic) BOOL locationEnabled;
@property (nonatomic) Location *location;

+ (instancetype)currentLocation;
- (double)calculateDistanceWithUserLat:(NSNumber *)userLat userLng:(NSNumber *)userLng
                              eventLat:(NSNumber *)eventLat
                              eventLng:(NSNumber *)eventLng;

@end
