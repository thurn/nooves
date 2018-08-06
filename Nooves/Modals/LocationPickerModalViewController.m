#import "LocationCell.h"
#import "Location.h"
#import "LocationPickerModalViewController.h"

#import <CoreLocation/CoreLocation.h>

static NSString * const baseURLString = @"https://api.foursquare.com/v2/venues/search?";
static NSString * const clientID = @"4FYRZKNIIFJQG25SUYJ55KINHUMVGWMYWFGQUFO5H4AQPQN2";
static NSString * const clientSecret = @"KYCXK12AGVWYVSH5QVEEI2CTCX1PSGRUMBZBLZ40WABD5VUP";

@interface LocationPickerModalViewController () <UITableViewDelegate, UITableViewDataSource,
UISearchBarDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) NSArray *results;
@end

@implementation LocationPickerModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    [self configureTableView];
    [self.view addSubview:self.tableView];

    self.lat = [[NSNumber alloc] init];
    self.lng = [[NSNumber alloc] init];
    self.location = [[NSString alloc] init];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    self.searchBar.delegate = self;
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;
    
    [self createBackButton];
    
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

// completes api request and stores searched results in dictionary
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
        [self fetchLocationsWithQuery:newText nearCityWithLatitude:self.userLat longitude:self.userLng];
    }
    return true;
}

// fetches places from search
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.userLat = Location.currentLocation.userLat;
    self.userLng = Location.currentLocation.userLng;
    if (searchBar.text.length > 2) {
        [self fetchLocationsWithQuery:searchBar.text nearCityWithLatitude:self.userLat
                            longitude:self.userLng];
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
    self.lat = [venue valueForKeyPath:@"location.lat"];
    self.lng = [venue valueForKeyPath:@"location.lng"];
    self.location = [venue valueForKeyPath:@"name"];
    NSLog(@"%@", self.location);
    NSLog(@"%@, %@", self.lat, self.lng);
    
    [self.locationDelegate locationsPickerModalViewController:self
                                  didPickLocationWithLatitude:self.lat
                                                    longitude:self.lng
                                                     location:self.location];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // changes the selected background view of the cell
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// TODO(Nikki): present alert controller if location services not enabled

@end
