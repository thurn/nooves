#import "Location.h"
#import "LocationPickerModalViewController.h"

@implementation Location

+ (instancetype)currentLocation {
    Location *location = [[Location alloc] init];
    location.userLocation = [[CLLocationManager alloc] init];
    location.userLocation.delegate = location;
    location.userLocation.desiredAccuracy = kCLLocationAccuracyBest;
    location.userLocation.distanceFilter = kCLDistanceFilterNone;
    
    if([CLLocationManager locationServicesEnabled]) {
        
        NSLog(@"Location Services Enabled");
        [location.userLocation requestAlwaysAuthorization];
        [location.userLocation requestWhenInUseAuthorization];
        [location.userLocation startUpdatingLocation];
        
        CLLocation *newLocation = [location.userLocation location];
        location.userLat = [[NSNumber alloc] initWithFloat:newLocation.coordinate.latitude];
        location.userLng = [[NSNumber alloc] initWithFloat:newLocation.coordinate.longitude];
    }
    
    return location;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error getting user location");
}

@end
