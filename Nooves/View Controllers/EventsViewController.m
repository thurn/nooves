#import "ComposeViewController.h"
#import "EventCell.h"
#import "EventsViewController.h"

static NSString * const baseURLString = @"http://api.eventful.com/json/events/search?";
static NSString * const appKey = @"dFXh3rhZVVwbshg9";

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property(strong, nonatomic) NSArray *eventsArray;
@property(strong, nonatomic) UISearchBar *searchBar;
@property(strong, nonatomic) NSArray *results;
@property(strong, nonatomic) NSString *userCity;
@property(strong, nonatomic) NSString *userState;
@end

@implementation EventsViewController

{
    UITableView *tableView;
    NSString *address;
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
    [tableView registerClass:[EventCell class] forCellReuseIdentifier:@"compressedEventCellIdentifier"];
    
    // get user's location from settings
    self.userCity = [NSUserDefaults.standardUserDefaults objectForKey:@"city"];
    self.userState = [NSUserDefaults.standardUserDefaults objectForKey:@"state"];
    
    if (![self.userCity isKindOfClass:[NSString class]] || ![self.userState isKindOfClass:[NSString class]]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error getting current location" message:@"Please set your current location in Settings" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *dismissAlert = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:dismissAlert];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
    }
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
    NSLog( @"fetching events for :%@", searchBar.text);
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
    tableView.rowHeight = UITableViewAutomaticDimension;
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
       EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"compressedEventCellIdentifier"];
    cell = [tableView dequeueReusableCellWithIdentifier:@"eventCellIdentifier" forIndexPath:indexPath];
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
    if ([self.userCity isKindOfClass:[NSString class]] && [self.userState isKindOfClass:[NSString class]]) {
        NSString *cityAndSpace = [self.userCity stringByAppendingString:@" "];
        NSString *loc = [cityAndSpace stringByAppendingString:self.userState];
        
        
        NSString *queryString = [NSString stringWithFormat:@"app_key=%@&page_size=100&location=%@&keywords=%@",appKey,loc,query];
        queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
            if (data) {
                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                self.results = [responseDictionary valueForKeyPath:@"events.event"];
                [self->tableView reloadData];
            }
        }];
        [task resume];
    }
   
    else {
        NSLog( @"the user city and state are null");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error getting current location" message:@"Please set your current location in Settings" preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *okAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
@end

