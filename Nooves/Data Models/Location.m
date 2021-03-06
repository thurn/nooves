#import "Location.h"
#import "LocationPickerModalViewController.h"

@implementation Location

+ (instancetype)currentLocation {
    
    static dispatch_once_t once;
    static Location *location;
    
    dispatch_once(&once, ^{
        location = [[Location alloc] init];
        location.userLocation = [[CLLocationManager alloc] init];
        });

    location.userLocation.delegate = location;
    location.userLocation.desiredAccuracy = kCLLocationAccuracyBest;
    location.userLocation.distanceFilter = kCLDistanceFilterNone;
    
    if([CLLocationManager locationServicesEnabled]) {
        [location.userLocation requestAlwaysAuthorization];
        [location.userLocation requestWhenInUseAuthorization];
        
        CLLocation *newLocation = [location.userLocation location];
        location.userLat = [[NSNumber alloc] initWithFloat:newLocation.coordinate.latitude];
        location.userLng = [[NSNumber alloc] initWithFloat:newLocation.coordinate.longitude];
    } else {
        NSLog(@"Location services not enabled");
    }
    return location;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error getting user location");
}

// calculates the distance between the user's location and an event's location
- (double)calculateDistanceWithUserLat:(NSNumber *)userLat userLng:(NSNumber *)userLng
                            eventLat:(NSNumber *)eventLat
                            eventLng:(NSNumber *)eventLng {
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:userLat.doubleValue longitude:userLng.doubleValue];
    CLLocation *eventLocation = [[CLLocation alloc] initWithLatitude:eventLat.doubleValue longitude:eventLng.doubleValue];
    
    CLLocationDistance distance = [userLocation distanceFromLocation:eventLocation];
    
    return distance;
}

@end
