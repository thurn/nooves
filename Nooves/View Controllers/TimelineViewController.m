#import "TimelineViewController.h"

#import "ComposeViewController.h"
#import "FilterViewController.h"
#import "ProfileViewController.h"
#import "PostDetailsViewController.h"
#import "UserViewController.h"

#import "Location.h"

#import "PureLayout/PureLayout.h"

#import <FIRDatabase.h>

@interface TimelineViewController ()
@property (strong, nonatomic) NSMutableArray *filteredData;
@property (nonatomic) BOOL filtered;
@property (nonatomic) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController {
    UITableView *tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.filtered) {
        [tableView reloadData];
    }
    self.navigationItem.hidesBackButton = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.filtered = NO;

    tableView = [self configureTableView];
    self.navigationItem.title = @"Home";
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = [UIColor whiteColor];
    [tableView registerClass:[PostCell class] forCellReuseIdentifier:@"postCellIdentifier"];
    [self.view addSubview:tableView];
    
    [self writeNewPost];
    [self filterResults];
    [self fetchPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)filteredArray:(NSArray *)array {
    self.filteredData = [NSMutableArray arrayWithArray:array];
    self.filtered = YES;
    [self.navigationController popToViewController:self animated:YES];
    
}

- (void)filterLocation {
    Location *location = [[Location alloc] init];
    self.filteredData = [[NSMutableArray alloc]init];
    double distance;
    for (Post *post in self.firArray) {
        if ([NSUserDefaults.standardUserDefaults boolForKey:@"switch"]) {
            [location calculateDistanceWithUserLat:[NSNumber numberWithDouble:33.448376]
                                           userLng:[NSNumber numberWithDouble:-112.074036]
                                          eventLat:post.activityLat
                                          eventLng:post.activityLng];
        } else {
            distance =
            [location calculateDistanceWithUserLat:Location.currentLocation.userLat
                                           userLng:Location.currentLocation.userLng
                                          eventLat:post.activityLat
                                          eventLng:post.activityLng];
        }
        if (distance <= 80467.2) {
            [self.filteredData addObject:post];
        }
    }
}

- (void)fetchPosts {
    FIRDatabaseReference * ref =[[FIRDatabase database] reference];
    [[[ref child:@"Users"] child:[FIRAuth auth].currentUser.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot.value isEqual:[NSNull null]]) {
            [[[ref child:@"Users"] child:[FIRAuth auth].currentUser.uid] setValue:@{@"Age":@(0), @"Bio":@"nil", @"Name":[FIRAuth auth].currentUser.displayName,@"PhoneNumber":@(0), @"ProfilePicURL":@"nil",@"EventsGoing":@[@"a"]}];
        }
    }];
    FIRDatabaseHandle *handle = [[ref child:@"Posts"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postsDict = snapshot.value;
        if (![postsDict isEqual:[NSNull null]]) {
            self.firArray = [Post readPostsFromFIRDict:postsDict];
            [self filterLocation];
            [self.refreshControl endRefreshing];
            [tableView reloadData];
        }
    }];
}


#pragma mark - buttons and actions

- (UIBarButtonItem *)writeNewPost {
    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] init];
    [composeButton setImage:[UIImage imageNamed:@"compose"]];
    self.navigationItem.rightBarButtonItem = composeButton;
    composeButton.target = self;
    composeButton.action = @selector(didTapCompose);

    return composeButton;
}

- (void)didTapCompose {
    ComposeViewController *composeViewCont = [[ComposeViewController alloc] init];
    UINavigationController *composeNavCont = [[UINavigationController alloc] initWithRootViewController:composeViewCont];
    [self.navigationController presentViewController:composeNavCont animated:YES completion:nil];
}

- (UIBarButtonItem *)filterResults {

    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] init];
    [filterButton setImage:[UIImage imageNamed:@"slider"]];
    self.navigationItem.leftBarButtonItem = filterButton;
    filterButton.target = self;
    filterButton.action = @selector(didTapFilter);

    return filterButton;
}

- (void)didTapFilter {
    FilterViewController *filterController = [[FilterViewController alloc]initWithArray:self.firArray];
    filterController.filterDelegate = self;
    UINavigationController *filterNavCont = [[UINavigationController alloc] initWithRootViewController:filterController];
    [self.navigationController presentViewController:filterNavCont animated:YES completion:nil];
}

-(void)didTapProfile {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profile animated:YES];
}

- (void)didTapProfilePic:(NSString *)userID {
    UserViewController *newUser = [[UserViewController alloc] initWithUserID:userID];
    [self.navigationController pushViewController:newUser animated:YES];
}

#pragma mark - UITableViewDelegate
- (UITableView *)configureTableView {
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    UITabBarController *tab = [UITabBarController new];
    CGRect tableViewFrame = CGRectMake(0, 0, width, height-tab.tabBar.frame.size.height-20);
    
    tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    
    return tableView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *pickedPost = self.filteredData[indexPath.row];
    PostDetailsViewController *postDetail = [[PostDetailsViewController alloc] initFromTimeline:pickedPost];
    [self.navigationController pushViewController:postDetail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell =[tableView dequeueReusableCellWithIdentifier:@"postCellIdentifier" forIndexPath:indexPath];
    cell.postDelegate = self;
    Post *newPost = self.filteredData[indexPath.row];
    [cell configurePost:newPost];
    return cell;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.filteredData){
        return self.filteredData.count;
    }
    return 1;
}



@end
