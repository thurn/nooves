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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self configureTableView];
    [self confirmEventButton];
    [tableView registerClass:[EventCell class] forCellReuseIdentifier:@"eventCellIdentifier"];
    [tableView reloadData];
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
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = self.eventsArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.eventsArray.count;
}

- (void)fetchEvents {
    NSString *queryString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&",clientKey, clientSecret];
    queryString = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
   // NSURL *url
    
}

@end

