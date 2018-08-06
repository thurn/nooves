
#import "ComposeViewController.h"
#import "FilterViewController.h"
#import <FIRDatabase.h>
#import "PostCell.h"
#import "ProfileViewController.h"
#import "PureLayout/PureLayout.h"
#import "TimelineViewController.h"
#import "PostDetailsViewController.h"
#import "Location.h"

@interface TimelineViewController ()
@property (strong, nonatomic) NSMutableArray *filteredData;
@property (nonatomic) BOOL filtered;
@property (nonatomic) UIRefreshControl *refreshControl;
@end

@implementation TimelineViewController {
    UITableView *tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.filtered) {
        [tableView reloadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.filtered = NO;

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
    [self fetchPosts];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    //  bind action to refresh control
    // TODO(Nikki): add timer to check if there's no posts to fetch then stop the refresh
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [tableView insertSubview:self.refreshControl atIndex:0];
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
    [composeButton setImage:[UIImage imageNamed:@"compose"]];
    self.navigationItem.rightBarButtonItem = composeButton;
    composeButton.target = self;
    composeButton.action = @selector(didTapCompose);

    return composeButton;
}

- (UIBarButtonItem *)filterResults {

    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] init];
    [filterButton setImage:[UIImage imageNamed:@"slider"]];
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
    Post *pickedPost = self.filteredData[indexPath.row];
    PostDetailsViewController *postDetail = [[PostDetailsViewController alloc] initFromTimeline:pickedPost];
    [self.navigationController pushViewController:postDetail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostCell *cell =[tableView dequeueReusableCellWithIdentifier:@"postCellIdentifier" forIndexPath:indexPath];
    Post *newPost = self.filteredData[indexPath.row];
    [cell configurePost:newPost];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.filteredData){
        return self.filteredData.count;
    }
    return 1;
}

- (void)didTapCompose {
    ComposeViewController *composeViewCont = [[ComposeViewController alloc] init];
    UINavigationController *composeNavCont = [[UINavigationController alloc] initWithRootViewController:composeViewCont];
    [self.navigationController presentViewController:composeNavCont animated:YES completion:nil];
}

- (void)didTapFilter {
    FilterViewController *filterController = [[FilterViewController alloc]initWithArray:self.firArray];
    filterController.filterDelegate = self;
    [self.navigationController pushViewController:filterController animated:YES];
}

-(void)didTapProfile {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profile animated:YES];
}

- (void)filteredArray:(NSArray *)array {;
    self.filteredData = [NSMutableArray arrayWithArray:array];
    self.filtered = YES;
    [self.navigationController popToViewController:self animated:YES];

}

- (NSArray *)filterLocation {
    Location *location = [[Location alloc] init];
    self.filteredData = [[NSMutableArray alloc]init];
    for (Post *post in self.firArray) {
        double distance =
        [location calculateDistanceWithUserLat:Location.currentLocation.userLat
                                           userLng:Location.currentLocation.userLng
                                          eventLat:post.activityLat
                                          eventLng:post.activityLng];
        if (distance <= 80467.2) {
            [self.filteredData addObject:post];
        }
    }
    return self.filteredData;
}

- (void)fetchPosts {
    static dispatch_once_t openingApp;
    dispatch_once(&openingApp, ^ {
        FIRDatabaseReference * ref =[[FIRDatabase database] reference];
        [[[ref child:@"Users"] child:[FIRAuth auth].currentUser.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if ([snapshot.value isEqual:[NSNull null]]) {
                [[[ref child:@"Users"] child:[FIRAuth auth].currentUser.uid] setValue:@{@"Age":@(0), @"Bio":@"nil", @"Name":[FIRAuth auth].currentUser.displayName,@"PhoneNumber":@(0), @"ProfilePicURL":@"nil",@"EventsGoing":@[@"a"]}];
            }
        }];
        FIRDatabaseHandle *handle = [[ref child:@"Posts"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *postsDict = snapshot.value;
            self.firArray = [Post readPostsFromFIRDict:postsDict];
            self.firArray = [self filterLocation];
            sleep(1);
            [self.refreshControl endRefreshing];
            [tableView reloadData];
        }];
    });
}
@end
