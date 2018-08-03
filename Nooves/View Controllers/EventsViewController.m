#import "ComposeViewController.h"
#import "EventCell.h"
#import "EventsViewController.h"

static NSString * const baseURLString = @"http://api.eventful.com/json/events/search?";
static NSString * const appKey = @"dFXh3rhZVVwbshg9";
static NSString * const clientKey = @"5db85641372af05aa023";
static NSString * const clientSecret = @"93767e5098b45988d73f";

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property(strong, nonatomic) NSArray *eventsArray;
@property(strong, nonatomic) UISearchBar *searchBar;

@end

@implementation EventsViewController {
    UITableView *tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Local Events";
    [self configureTableView];
    
    // set up the search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    self.searchBar.delegate = self;
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    self.searchBar.placeholder = @"Enter your location...";
    searchBarView.autoresizingMask = 0;
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;
    
    [tableView reloadData];
    
     [tableView registerClass:[EventCell class] forCellReuseIdentifier:@"eventCellIdentifier"];
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
    NSLog( @"fetching events from the search bar");
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
    
    return tableView;
}

#pragma mark - UITableViewDelegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCellIdentifier" forIndexPath:indexPath];
    if(self.results.count > indexPath.row) {
        [cell updateWithEvent:self.results[indexPath.row]];
        return cell;
    }
    return cell;
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
    NSString *description = @"Description";
    NSString *venue = events[@"venue_name"];
    [self.eventsDelegate eventsViewController:self didSelectEventWithTitle:title withDescription:description withVenue:venue];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)fetchEventsWithQuery:(NSString *)query {
    NSString *queryString = [NSString stringWithFormat:@"app_key=%@&location=%@",appKey,query];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:[baseURLString stringByAppendingString:queryString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        if (data) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"response:%@", responseDictionary);
            self.results = [responseDictionary valueForKeyPath:@"events.event"];
            [tableView reloadData];
        }
    }];
    [task resume];
}

@end

