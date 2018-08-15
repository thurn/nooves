#import <ChameleonFramework/Chameleon.h>
#import "ComposeViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "EventCell.h"
#import "EventsViewController.h"

#import <Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>

static NSString * const baseURLString = @"http://api.eventful.com/json/events/search?";
static NSString * const appKey = @"dFXh3rhZVVwbshg9";

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate>

@property(strong, nonatomic) NSArray *eventsArray;
@property(strong, nonatomic) UISearchBar *searchBar;
@property(strong, nonatomic) NSArray *results;
@property(strong, nonatomic) NSString *userLocation;
@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) UITableView *tableView;

@end

@implementation EventsViewController

{
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
    
    [self.tableView reloadData];
    [self.tableView registerClass:[EventCell class] forCellReuseIdentifier:@"eventCellIdentifier"];
    
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
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.userInteractionEnabled = YES;
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = UIColor.flatSkyBlueColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setNeedsLayout];
    self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0);
    
    [self.tableView reloadData];
    return self.tableView;
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
    
    cell.backgroundColor = UIColor.whiteColor;
    cell.layer.borderColor = UIColor.blackColor.CGColor;
    cell.layer.borderWidth = 0.5;
    cell.layer.cornerRadius = 15;
    cell.clipsToBounds = YES;
    
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
    NSString *time = events[@"start_time"];
    NSString *eventLatitude = events[@"latitude"];
    NSString *eventLongitude = events[@"longitude"];
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc]init];
    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *formattedLatitude = [numFormatter numberFromString:eventLatitude];
    NSNumber *formattedLongitude = [numFormatter numberFromString:eventLongitude];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    [formatter setTimeZone: [NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateString = [formatter dateFromString:time];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString *formattedDate = [formatter stringFromDate:dateString];
   
    [self.eventsDelegate eventsViewController:self didSelectEventWithTitle:title withDescription:description withVenue:venue withTime:formattedDate withLatitude:formattedLatitude withLongitude:formattedLongitude];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (selectedCellIndexPath == indexPath) {
        selectedCellIndexPath = nil;
    }
    
    else {
        selectedCellIndexPath = indexPath;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}


- (void)fetchEventsWithQuery:(NSString *)query {
    if ([self.userLocation isKindOfClass:[NSString class]]) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *queryString = [NSString stringWithFormat:@"app_key=%@&page_size=10&location=%@&keyword=%@",appKey,self.userLocation,query];
            queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
            NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
                if (data) {
                    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    self.results = [responseDictionary valueForKeyPath:@"events.event"];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.tableView reloadData];
                    NSLog(@" results dictionary :%@", self.results);
                }
            }];
            [task resume];
    }
    
    else {
        UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to get your location" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [errorAlert addAction:dismiss];
            [self presentViewController:errorAlert animated:YES completion:nil];
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

