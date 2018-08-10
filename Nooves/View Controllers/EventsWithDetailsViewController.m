#import "EventsWithDetailsViewController.h"
#import "EventCell.h"
#import <HVTableView/HVTableView.h>

static NSString * const baseURLString = @"http://api.eventful.com/json/events/search?";
static NSString * const appKey = @"dFXh3rhZVVwbshg9";

@interface EventsWithDetailsViewController () <HVTableViewDataSource, HVTableViewDelegate, EventCellDelegate, UISearchBarDelegate>

@property(strong, nonatomic) HVTableView *tableView;
@property(strong, nonatomic) NSArray *eventsArray;
@property(strong, nonatomic) UISearchBar *searchBar;
@property(strong, nonatomic) NSArray *results;
@property(strong, nonatomic) NSString *userCity;
@property(strong, nonatomic) NSString *userState;
@property BOOL isExpanded;

@end

@implementation EventsWithDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    [self.tableView registerClass:[EventCell class] forCellReuseIdentifier:@"eventCellIdentifier"];
    [self.tableView reloadData];
    
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

- (HVTableView *)configureTableView {
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake( 0, 0, width, height);
    
    self.tableView = [[HVTableView alloc]initWithFrame:tableViewFrame];
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.userInteractionEnabled = YES;
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.HVTableViewDataSource = self;
    self.tableView.HVTableViewDelegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    
    [self.tableView reloadData];
    return self.tableView;
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
                [self.tableView reloadData];
            }
        NSLog(@"results dictionary :%@", self.results);
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

#pragma mark - HVTableViewDataSource
- (void)tableView:(UITableView *)tableView expandCell:(EventCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    cell.confirmButton.alpha = 0;
    
    [UIView animateWithDuration:.5 animations:^{
        cell.descriptionLabel.text = self.results[indexPath.row][@"description"];
        cell.confirmButton.alpha = 1;
        cell.arrow.transform = CGAffineTransformMakeRotation(0);
    }];
}

- (void)tableView:(UITableView *)tableView collapseCell:(EventCell *)cell withIndexPath:(NSIndexPath *)indexPath {
    cell.confirmButton.alpha = 0;
    cell.arrow.transform = CGAffineTransformMakeRotation(0);
    cell.descriptionLabel.text = @"Click for description";
    
    [UIView animateWithDuration:0.5 animations:^{
        cell.arrow.transform = CGAffineTransformMakeRotation(-M_PI+0.00);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.eventsArray) {
        return  self.eventsArray.count;
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCellIdentifier" forIndexPath:indexPath];
    cell.delegate = self;
    [cell initialize];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.titleLabel.text = self.results[indexPath.row][@"title"];
    cell.venueLabel.text = self.results[indexPath.row][@"venue_name"];
    
    if (!isExpanded) {
        cell.descriptionLabel.text = @"Click for description";
        cell.arrow.transform = CGAffineTransformMakeRotation(M_PI);
    }
    
    else {
        NSString *descriptionText = self.results[indexPath.row][@"description"];
        
        if([descriptionText isKindOfClass:[NSString class]]) {
            cell.descriptionLabel.text = descriptionText;
            [cell.descriptionLabel setNumberOfLines:0];
        }
        
        else {
            cell.descriptionLabel.text = @"No description available for this event";
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath isExpanded:(BOOL)isExpanded {
    
    if (isExpanded) {
        return 150;
    }
    return 70;
}


- (void)didTapConfirmEvent:(EventCell *)cell {
    NSLog(@"I want to confirm this event");
}


@end
