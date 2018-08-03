#import "ComposeViewController.h"
#import "EventCell.h"
#import "EventsViewController.h"

static NSString * const baseURLString = @"http://api.eventful.com/json/events/search?";
static NSString * const appKey = @"dFXh3rhZVVwbshg9";
static NSString * const clientKey = @"5db85641372af05aa023";
static NSString * const clientSecret = @"93767e5098b45988d73f";

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource>

@property(strong, nonatomic) NSArray *eventsArray;

@end

@implementation EventsViewController {
    UITableView *tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Local Events";
    
    [self configureTableView];
    [self confirmEventButton];
    [self fetchEventsWithQuery:@"london"];
   
    [tableView reloadData];
    
     [tableView registerClass:[EventCell class] forCellReuseIdentifier:@"eventCellIdentifier"];
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

// sets up post button properties
- (UIBarButtonItem *)confirmEventButton {
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"Confirm"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(didTapConfirm)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    return confirmButton;
}

- (void)didTapConfirm {
    ComposeViewController *compose = [[ComposeViewController alloc]init];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDelegate methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCellIdentifier" forIndexPath:indexPath];
   // cell.textLabel.text = self.eventsArray[indexPath.row];
    Event *event = self.eventsArray[indexPath.row];
    [cell configureEvent:event];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.eventsArray) {
        return  self.eventsArray.count;
    }
    return 30;
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
            [tableView reloadData];
        }
    }];
    [task resume];
}

@end

