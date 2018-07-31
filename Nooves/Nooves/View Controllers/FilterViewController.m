#import "ComposeViewController.h"
#import "FilterCell.h"
#import "FilterViewController.h"
#import "PureLayout/PureLayout.h"
#import "TimelineViewController.h"
#import "Post.h"
#import "PostCell.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UIButton *confirmButton;
@property(strong, nonatomic) NSArray *categories;
@property(strong, nonatomic) NSMutableArray *selectedCategories;
@property(strong, nonatomic) NSMutableArray *filteredData;

@end

@implementation FilterViewController
{
    CGFloat x;
    CGFloat y;
    UIBarButtonItem *allPosts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configureTableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self configureCategoriesArray];
    [self configureConfirmButton];
    [self allPostsButton];
    
    [self.tableView registerClass:[FilterCell class] forCellReuseIdentifier:@"filterCellIdentifier"];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)configureTableView {
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake( 0, 0, width, height);
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.userInteractionEnabled = YES;
    [self.view addSubview:self.tableView];
    
    return self.tableView;
}

- (UIBarButtonItem *)allPostsButton {
    allPosts = [[UIBarButtonItem alloc]init];
    allPosts.title = @"All Posts";
    self.navigationItem.rightBarButtonItem = allPosts;
    allPosts.target = self;
    allPosts.action = @selector(didTapAllPosts);
    
    return allPosts;
}

- (NSArray *)configureCategoriesArray {
    self.categories= @[@"Outdoors", @"Shopping", @"Partying", @"Eating",@"Arts", @"Sports", @"Networking", @"Fitness", @"Games", @"Concert", @"Cinema", @"Festival", @"Other"];
    return self.categories;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FilterCell *cell =[tableView dequeueReusableCellWithIdentifier:@"filterCellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = self.categories[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.categories){
        return self.categories.count;
    }
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *customcell = [tableView cellForRowAtIndexPath:indexPath];
    if (customcell.accessoryType == UITableViewCellAccessoryNone) {
        customcell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        customcell.accessoryType=UITableViewCellAccessoryNone;
    }
}

- (void)configureConfirmButton {
    self.confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(200, 600, 30, 30)];
    [self.confirmButton setBackgroundColor:[UIColor blueColor]];
    [self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.confirmButton sizeToFit];
    [self.view addSubview:self.confirmButton];
    [self.confirmButton addTarget:self action:@selector(didTapConfirm) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapConfirm {
    self.selectedCategories = [[NSMutableArray alloc]init];
    self.filteredData = [[NSMutableArray alloc]init];
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [self.selectedCategories addObject:cell.textLabel.text];
        }
    }
    
    // Read data from the database and filter according to the categories
    FIRDatabaseReference *reference = [[FIRDatabase database]reference];
    FIRDatabaseHandle *databaseHandle = [[reference child:@"Posts"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *posts = snapshot.value;
        
        for(NSString *userID in posts) {
            for(NSString *postID in posts[userID]) {
                for (NSString *chosenActivity in self.selectedCategories) {
                    Post *post = [[Post alloc]init];
                    post.fireBaseID = postID;
                    post.userID = userID;
                    post.activityType = [posts[userID][postID][@"Activity Type"] doubleValue];
                    post.activityTitle = posts[userID] [postID][@"Title"];
                    post.activityDescription = posts[userID][postID][@"Description"];
                    post.activityLat = posts[userID][postID][@"Latitude"];
                    post.activityLng = posts[userID][postID][@"Longitude"];
                    NSInteger date = [posts[userID][postID][@"Date"]integerValue];
                    NSDate *convertedDate = [NSDate dateWithTimeIntervalSince1970:date];
                    post.activityDateAndTime = convertedDate;
                    NSString *activity = [Post activityTypeToString:post.activityType];
                    if ([activity isEqualToString:chosenActivity]) {
                        [self.filteredData addObject:post];
                    }
                }
            }
        }
        NSLog(@"%@",self.filteredData);
    }];
    
    TimelineViewController *feed = [[TimelineViewController alloc]init];
    feed.firArray = self.filteredData;
    [self.navigationController pushViewController:feed animated:YES];
}

- (void)didTapAllPosts {
    TimelineViewController *timeline = [[TimelineViewController alloc]init];
   // timeline.tempPostsArray = self.tempPostsArrayCopy;
    [self.navigationController pushViewController:timeline animated:YES];
}

@end
