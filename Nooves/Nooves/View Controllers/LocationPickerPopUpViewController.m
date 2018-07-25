#import "ComposeViewController.h"
#import "LocationCell.h"
#import "LocationPickerPopUpViewController.h"

static NSString * const clientID = @"4FYRZKNIIFJQG25SUYJ55KINHUMVGWMYWFGQUFO5H4AQPQN2";
static NSString * const clientSecret = @"KYCXK12AGVWYVSH5QVEEI2CTCX1PSGRUMBZBLZ40WABD5VUP";

@interface LocationPickerPopUpViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) NSArray *results;
@property (nonatomic) UIPickerView *pickerView;

@end

@implementation LocationPickerPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configureTableView];
    [self.view addSubview:self.tableView];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    self.searchBar.delegate = self;
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.tableView reloadData];
}

- (void)configureTableView {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake( x, y, width, height);
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    [self.tableView registerClass:[LocationCell class] forCellReuseIdentifier:@"LocationCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.userInteractionEnabled = YES;
}

// cancel button appears when user edits search
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

// will delete search text when cancel button click
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

// opens category picker view
- (UIButton *)selectLocation{
    UIButton *selectLocation = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectLocation setTitle:@"Select location" forState:UIControlStateNormal];
    [selectLocation addTarget:self action:@selector(didTapSelectLocation) forControlEvents:UIControlEventTouchUpInside];
    [selectLocation sizeToFit];
    return selectLocation;
}

// passes post data and jumps back to composer view controller
- (void)didTapSelectLocation{
    ComposeViewController *composer = [[ComposeViewController alloc] init];
    composer.tempPostsArray = self.tempPostsArray;
    composer.date = self.date;
    composer.activityType = self.activityType;
    composer.lat = self.lat;
    composer.lng = self.lng;
    [self.navigationController pushViewController:composer animated:YES];
}

// returns number of results from search
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

// populates searched data
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationCell"
                                                         forIndexPath:indexPath];
    [cell updateWithLocation:self.results[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // This is the selected venue
    NSDictionary *venue = self.results[indexPath.row];
    self.lat = [venue valueForKeyPath:@"location.lat"];
    self.lng = [venue valueForKeyPath:@"location.lng"];
    self.location = [venue valueForKeyPath:@"name"];
    NSLog(@"%@", self.location);
    NSLog(@"%@, %@", self.lat, self.lng);
    
    // [self.delegate locationsPickerPopUpViewController:(LocationPickerPopUpViewController *)self didPickLocationWithLatitude:self.lat longitude:self.lng];
    [self.delegate locationsPickerPopUpViewController:(LocationPickerPopUpViewController *)self didPickLocationWithLatitude:self.lat longitude:self.lng location:self.location];
    
    ComposeViewController *composer = [[ComposeViewController alloc] init];
    composer.lat = self.lat;
    composer.lng = self.lng;
    composer.location = self.location;
    
    [self.navigationController pushViewController:composer animated:YES];
    
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *newText = [searchBar.text stringByReplacingCharactersInRange:range withString:text];
    [self fetchLocationsWithQuery:newText nearCity:@"San Francisco"];
    return true;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self fetchLocationsWithQuery:searchBar.text nearCity:@"San Francisco"];
}

- (void)fetchLocationsWithQuery:(NSString *)query nearCity:(NSString *)city {
    NSString *baseURLString = @"https://api.foursquare.com/v2/venues/search?";
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&v=20141020&near=%@,CA&query=%@", clientID, clientSecret, city, query];
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

- (void)locationsPickerPopUpViewController:(LocationPickerPopUpViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude location:(NSString *)location {
}

@end
