#import "AppDelegate.h"
#import "ComposeViewController.h"
#import "FilterViewController.h"
#import <FIRDatabase.h>
#import "PostCell.h"
#import "ProfileViewController.h"
#import "PureLayout/PureLayout.h"
#import "TimelineViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PostDetailsViewController.h"

@interface TimelineViewController () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *userLocation;

@end

@implementation TimelineViewController
{
    UITableView *tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userLocation = [[CLLocationManager alloc] init];
    self.userLocation.delegate = self;
    self.userLocation.desiredAccuracy = kCLLocationAccuracyBest;
    self.userLocation.distanceFilter = kCLDistanceFilterNone;
    
    if([CLLocationManager locationServicesEnabled]) {
        
        NSLog(@"Location Services Enabled");
        [self.userLocation startUpdatingLocation];
        [self.userLocation requestAlwaysAuthorization];
        [self.userLocation requestWhenInUseAuthorization];
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"App Permission Denied"
                                                                           message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            
            // create an OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                             }];
            [alert addAction:okAction];
        }
    }

    static dispatch_once_t openingApp;
    dispatch_once(&openingApp, ^ {
    FIRDatabaseReference * ref =[[FIRDatabase database] reference];
    FIRDatabaseHandle *handle = [[ref child:@"Posts"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postsDict = snapshot.value;
        self.firArray = [Post readPostsFromFIRDict:postsDict];
        [tableView reloadData];
    }];
    });
    
    tableView = [self configureTableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    
    self.navigationItem.title = @"Home";
    [self writeNewPost];
    [self filterResults];
    
    [tableView registerClass:[PostCell class] forCellReuseIdentifier:@"postCellIdentifier"];
}

- (UITableView *)configureTableView {
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake(0, 0, width, height);

    tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;

    return tableView;
}

- (UIBarButtonItem *)writeNewPost {
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] init];
    composeButton.title = @"New Post";
    self.navigationItem.rightBarButtonItem = composeButton;
    composeButton.target = self;
    composeButton.action = @selector(didTapCompose);

    return composeButton;
}

- (UIBarButtonItem *)filterResults {
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] init];
    filterButton.title = @"Filter";
    [filterButton setImage:[UIImage imageNamed:@"filter-icon.png"]];
    self.navigationItem.leftBarButtonItem = filterButton;
    filterButton.target = self;
    filterButton.action = @selector(didTapFilter);
    
    return filterButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *pickedPost = self.firArray[indexPath.row];
    PostDetailsViewController *postDetail = [[PostDetailsViewController alloc] initFromTimeline:pickedPost];
    [self.navigationController pushViewController:postDetail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell =[tableView dequeueReusableCellWithIdentifier:@"postCellIdentifier" forIndexPath:indexPath];
    Post *newPost =self.firArray[indexPath.row];
    [cell configurePost:newPost];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.firArray){
        return self.firArray.count;
    }
    return 30;
}

- (void)didTapCompose {
    ComposeViewController *composeViewCont = [[ComposeViewController alloc] init];
    UINavigationController *composeNavCont = [[UINavigationController alloc] initWithRootViewController:composeViewCont];
    [self.navigationController presentViewController:composeNavCont animated:YES completion:nil];
}

- (void)didTapFilter {
    FilterViewController *filter = [[FilterViewController alloc]init];
    // TODO(Norette): fetch data from the database
    [self.navigationController pushViewController:filter animated:YES];
}

-(void)didTapProfile {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profile animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations.lastObject;
    NSString *userLat = [[NSString alloc] initWithFormat:@"%f", newLocation.coordinate.latitude];
    NSString *userLng = [[NSString alloc] initWithFormat:@"%f", newLocation.coordinate.longitude];
    NSString *acc = [[NSString alloc] initWithFormat:@"%f", newLocation.horizontalAccuracy];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:@"Error obtaining location. Please make sure to set location access and turn your location on."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:^{
    }];
    
}

@end
