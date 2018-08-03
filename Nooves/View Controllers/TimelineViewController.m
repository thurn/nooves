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

@interface TimelineViewController ()

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
        [[[ref child:@"Usera"] child:[FIRAuth auth].currentUser.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if ([snapshot.value isEqual:[NSNull null]]) {
                [ref setValue:@{@"Age":@(0), @"Bio":@"nil", @"Name":[FIRAuth auth].currentUser.displayName,@"PhoneNumber":@(0), @"ProfilePicURL":@"nil",@"EventsGoing":@[@"a"]}];
            }
        }];
//    FIRDatabaseHandle *handle = [[ref child:@"Posts"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
//        NSDictionary *postsDict = snapshot.value;
//        self.firArray = [Post readPostsFromFIRDict:postsDict];
//        [tableView reloadData];
//    }];
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
    // TODO(Nikki): return posts with event locations within 50 miles from user's location
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
    [self.navigationController pushViewController:filter animated:YES];
}

-(void)didTapProfile {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profile animated:YES];
}

// TODO(Nikki): retrieve posts only within a certain region (50 miles) of user

@end
