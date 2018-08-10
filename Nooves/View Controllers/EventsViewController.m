#import "ComposeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "EventCell.h"
#import "EventsViewController.h"

static NSString * const baseURLString = @"http://api.eventful.com/json/events/search?";
static NSString * const appKey = @"dFXh3rhZVVwbshg9";

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate>

@property(strong, nonatomic) NSArray *eventsArray;
@property(strong, nonatomic) UISearchBar *searchBar;
@property(strong, nonatomic) NSArray *results;
@property(strong, nonatomic) NSString *userLocation;
@property(strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation EventsViewController

{
    UITableView *tableView;
    NSIndexPath *selectedCellIndexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Local Events";
    [self configureTableView];
    [self createBackButton];
    
    // set up the search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    self.searchBar.delegate = self;
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    self.searchBar.placeholder = @"Enter search keyword...";
    searchBarView.autoresizingMask = 0;
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;
    
    [tableView reloadData];
    [tableView registerClass:[EventCell class] forCellReuseIdentifier:@"eventCellIdentifier"];
    
    // Get user's current location
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated {
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = self.locationManager.location.coordinate.latitude;
    coordinate.longitude = self.locationManager.location.coordinate.longitude;
    
    CLLocation *loc = [[CLLocation alloc]initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        NSString *userCity = placemark.locality;
        NSString *userState = placemark.administrativeArea;
        NSString *cityAndSpace = [userCity stringByAppendingString:@" "];
        self.userLocation= [cityAndSpace stringByAppendingString:userState];
        NSLog(@"User location :%@", self.userLocation);
        [self.locationManager stopUpdatingLocation];
        
    }];
}
// cancel button appears when user edits search bar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

// will delete search text when cancel button clicked
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    self.searchBar.placeholder = @"Enter your location...";
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog( @"fetching events for :%@ about :%@",self.userLocation, searchBar.text);
      [self fetchEventsWithQuery:searchBar.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)configureTableView {
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake( 0, 0, width, height);
    
    tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    [self.view addSubview:tableView];
    
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 150;
    tableView.estimatedRowHeight = 80;
    [tableView setNeedsLayout];
    tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    
    [tableView reloadData];
    return tableView;
}

// set up the back button
- (UIBarButtonItem *)createBackButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back-icon"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(didTapBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;
    return backButton;
}

- (void)didTapBackButton {
     [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITableViewDelegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"eventCellIdentifier" forIndexPath:indexPath];
    if(self.results.count > indexPath.row) {
        [cell updateWithEvent:self.results[indexPath.row]];
        return cell;
    }
    else {
        return cell;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.eventsArray) {
        return  self.eventsArray.count;
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *events = self.results[indexPath.row];
    NSString *title = events[@"title"];
    NSString *description = events[@"description"];
    NSString *venue = events[@"venue_name"];
   
    [self.eventsDelegate eventsViewController:self didSelectEventWithTitle:title withDescription:description withVenue:venue];
    [self dismissViewControllerAnimated:NO completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)fetchEventsWithQuery:(NSString *)query {
    
    if ([self.userLocation isKindOfClass:[NSString class]]) {
            NSString *queryString = [NSString stringWithFormat:@"app_key=%@&page_size=100&location=%@&keyword=%@",appKey,self.userLocation,query];
            queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
            NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
                if (data) {
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    self.results = [responseDictionary valueForKeyPath:@"events.event"];
                    [self->tableView reloadData];
                    NSLog(@" results dictionary :%@", self.results);
                }
            }];
            [task resume];
    }
    
    else {
        NSLog(@" set your phone location");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error retrieving data"
                                                                       message:@"Please enable your location services in your settings to search for local events."
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                        }];
        [alert addAction:okAlert];
        
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedCellIndexPath != nil && [selectedCellIndexPath compare:indexPath] == NSOrderedSame) {
        return tableView.rowHeight *2;
    }
    return tableView.rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to get your location" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [errorAlert addAction:dismiss];
        [self presentViewController:errorAlert animated:YES completion:nil];
    }];
}
@end

