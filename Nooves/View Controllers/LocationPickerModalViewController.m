#import "LocationCell.h"
#import "Location.h"
#import "LocationPickerModalViewController.h"
#import "SettingsViewController.h"

#import "Chameleon.h"
#import <CoreLocation/CoreLocation.h>

static NSString * const baseURLString = @"https://api.foursquare.com/v2/venues/search?";
static NSString * const clientID = @"4FYRZKNIIFJQG25SUYJ55KINHUMVGWMYWFGQUFO5H4AQPQN2";
static NSString * const clientSecret = @"KYCXK12AGVWYVSH5QVEEI2CTCX1PSGRUMBZBLZ40WABD5VUP";

@interface LocationPickerModalViewController () <UITableViewDelegate, UITableViewDataSource,
UISearchBarDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) NSArray *results;
@property (nonatomic) NSNumber *eventlat;
@property (nonatomic) NSNumber *eventLng;
@property (nonatomic) NSString *location;
@property (nonatomic) NSNumber *userLng;
@property (nonatomic) NSNumber *userLat;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;

@end

@implementation LocationPickerModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor flatWhiteColor];
    self.navigationController.navigationBarHidden = NO;
    [self configureTableView];
    [self.view addSubview:self.tableView];

    self.eventlat = [[NSNumber alloc] init];
    self.eventLng = [[NSNumber alloc] init];
    self.location = [[NSString alloc] init];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    self.searchBar.delegate = self;
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;
    
    [self createBackButton];
    [self checkLocationEnabled];
    
    [self.tableView registerClass:[LocationCell class] forCellReuseIdentifier:@"LocationCell"];
    [self.tableView reloadData];
}

// congigures table view properties
- (UITableView *)configureTableView {
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake(0, 0, width, height);
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.userInteractionEnabled = YES;
    [self.view addSubview:self.tableView];
    
    return self.tableView;
}

// completes api request and stores searched results in dictionary based on user location
- (void)fetchLocationsWithQuery:(NSString *)query nearCityWithLatitude:(NSNumber *)latitude
                      longitude:(NSNumber *)longitude {
    NSString *queryLat = [NSString stringWithFormat:@"%@,", latitude];
    NSString *queryLng = [NSString stringWithFormat:@"%@", longitude];
    NSMutableString * ll = [[NSMutableString alloc] initWithString:queryLat];
    [ll appendString:queryLng];
    
    NSString *queryString =
    [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&ll=%@&query=%@", clientID, clientSecret, ll, query];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:
                             [NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task =
    [session dataTaskWithRequest:request
               completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:0
                                                                                 error:nil];
            NSLog(@"response: %@", responseDictionary);
            self.results = [responseDictionary valueForKeyPath:@"response.venues"];
            [self.tableView reloadData];
        }
    }];
    [task resume];
}

// completes api request and stores search results in dictionary based on inputted city and state
- (void)fetchLocationsWithQuery:(NSString *)query nearCity:(NSString *)city state:(NSString *)state {
    NSString *input = [NSString stringWithFormat:@"%@, %@", city, state];
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@&query=%@", clientID, clientSecret, input, query];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"response: %@", responseDictionary);
            self.results = [responseDictionary valueForKeyPath:@"response.venues"];
            [self.tableView reloadData];
        }
    }];
    [task resume];
}

// sets up back button properties
- (UIBarButtonItem *)createBackButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(didTapBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;
    return backButton;
}

// goes back to parent controller
- (void)didTapBackButton {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UISearchBarDelegate

// cancel button appears when user edits search bar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

// will delete search text when cancel button clicked
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

// finds places in a certain range of a city during search
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range
  replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    self.userLat = Location.currentLocation.userLat;
    self.userLng = Location.currentLocation.userLng;
    
    if (newText.length > 2) {
        if ((self.userLat == 0 && self.userLng == 0) || [NSUserDefaults.standardUserDefaults boolForKey:@"switch"]) {
            NSLog(@"Cannot retrieve user location");
            self.city = [NSUserDefaults.standardUserDefaults objectForKey:@"city"];
            self.state = [NSUserDefaults.standardUserDefaults objectForKey:@"state"];
            
            [self fetchLocationsWithQuery:newText nearCity:self.city state:self.state];
        } else {
            [self fetchLocationsWithQuery:newText
                     nearCityWithLatitude:self.userLat
                                longitude:self.userLng];
        }
    }
    return true;
}

// fetches places from search
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.userLat = Location.currentLocation.userLat;
    self.userLng = Location.currentLocation.userLng;
    if (searchBar.text.length > 2) {
        if ((self.userLat == 0 && self.userLng == 0) || [NSUserDefaults.standardUserDefaults boolForKey:@"switch"]) {
            NSLog(@"Cannot retrieve user location");
            self.city = [NSUserDefaults.standardUserDefaults objectForKey:@"city"];
            self.state = [NSUserDefaults.standardUserDefaults objectForKey:@"state"];
            [self fetchLocationsWithQuery:searchBar.text nearCity:self.city state:self.state];
        } else {
            [self fetchLocationsWithQuery:searchBar.text
                     nearCityWithLatitude:self.userLat
                                longitude:self.userLng];
        }
    }
}

#pragma mark - UITableViewDataSource

// returns number of results from search
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

// sets cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UITableViewDelegate

// populates searched data
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"
                                                         forIndexPath:indexPath];
    [cell updateWithLocation:self.results[indexPath.row]];
    return cell;
}

// saves location properties to compose view when cell selected
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the selected venue
    NSDictionary *venue = self.results[indexPath.row];
    self.eventlat = [venue valueForKeyPath:@"location.lat"];
    self.eventLng = [venue valueForKeyPath:@"location.lng"];
    self.location = [venue valueForKeyPath:@"name"];
    NSLog(@"%@", self.location);
    NSLog(@"%@, %@", self.eventlat, self.eventLng);
    
    [self.locationDelegate locationsPickerModalViewController:self
                                  didPickLocationWithLatitude:self.eventlat
                                                    longitude:self.eventLng
                                                     location:self.location];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // changes the selected background view of the cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// presents alert controller if location services not enabled
- (void)checkLocationEnabled {
    if(![CLLocationManager locationServicesEnabled]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error retrieving data"
                                                                       message:@"Please enable your location services."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        
        // create an OK action
        UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  // handle response here.
                                                              }];
        // add the OK action to the alert controller
        [alert addAction:okAlert];
        
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
        }];
    }
}

@end
