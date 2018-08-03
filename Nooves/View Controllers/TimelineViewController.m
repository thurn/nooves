#import "AppDelegate.h"
#import "ComposeViewController.h"
#import "FilterViewController.h"
#import <FIRDatabase.h>
#import "PostCell.h"
#import "Post.h"
#import "ProfileViewController.h"
#import "PureLayout/PureLayout.h"
#import "TimelineViewController.h"
#import "PostDetailsViewController.h"
#import "Location.h"

@interface TimelineViewController ()
@property (nonatomic) NSMutableArray *filteredData;
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
    [tableView reloadData];
    }];
    });

    self.filteredData = [[NSMutableArray alloc]init];

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
    Location *location = [[Location alloc] init];
    FIRDatabaseReference *reference = [[FIRDatabase database]reference];
    FIRDatabaseHandle databaseHandle = [[reference child:@"Posts"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *posts = snapshot.value;

        for(NSString *userID in posts) {
            for(NSString *postID in posts[userID]) {
                    Post *post = [[Post alloc]init];
                    post.fireBaseID = postID;
                    post.userID = userID;
                    post.activityType = [posts[userID][postID][@"Activity Type"] doubleValue];
                    post.activityTitle = posts[userID] [postID][@"Title"];
                    post.activityDescription = posts[userID][postID][@"Description"];
                    post.activityLat = posts[userID][postID][@"Latitude"];
                    post.activityLng = posts[userID][postID][@"Longitude"];
                    post.eventLocation = posts[userID][postID][@"Location"];
                    NSInteger date = [posts[userID][postID][@"Date"]integerValue];
                    NSDate *convertedDate = [NSDate dateWithTimeIntervalSince1970:date];
                    post.activityDateAndTime = convertedDate;
                double distance =
                [location calculateDistanceWithUserLat:Location.currentLocation.userLat
                                               userLng:Location.currentLocation.userLng
                                              eventLat:post.activityLat
                                              eventLng:post.activityLng];
                    if (distance <= 80467.2) {
                        [self.filteredData addObject:post];
                    }
            }
        }
        _firArray = self.filteredData;
    }];
        Post *newPost = self.firArray[indexPath.row];
        [cell configurePost:newPost];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.firArray){
        Location *location = [[Location alloc] init];
        FIRDatabaseReference *reference = [[FIRDatabase database]reference];
       FIRDatabaseHandle databaseHandle = [[reference child:@"Posts"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *posts = snapshot.value;

            for(NSString *userID in posts) {
                for(NSString *postID in posts[userID]) {
                    Post *post = [[Post alloc]init];
                    post.fireBaseID = postID;
                    post.userID = userID;
                    post.activityType = [posts[userID][postID][@"Activity Type"] doubleValue];
                    post.activityTitle = posts[userID] [postID][@"Title"];
                    post.activityDescription = posts[userID][postID][@"Description"];
                    post.activityLat = posts[userID][postID][@"Latitude"];
                    post.activityLng = posts[userID][postID][@"Longitude"];
                    post.eventLocation = posts[userID][postID][@"Location"];
                    NSInteger date = [posts[userID][postID][@"Date"]integerValue];
                    NSDate *convertedDate = [NSDate dateWithTimeIntervalSince1970:date];
                    post.activityDateAndTime = convertedDate;
                    double distance =
                    [location calculateDistanceWithUserLat:Location.currentLocation.userLat
                                                   userLng:Location.currentLocation.userLng
                                                  eventLat:post.activityLat
                                                  eventLng:post.activityLng];
                    if (distance <= 80467.2) {
                        [self.filteredData addObject:post];
                    }
                }
            }
            _firArray = self.filteredData;
        }];
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
    [self.navigationController pushViewController:filter animated:YES];
}

-(void)didTapProfile {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profile animated:YES];
}

@end
