#import <ChameleonFramework/Chameleon.h>
#import "ComposeViewController.h"
#import "FilterCell.h"
#import "FilterViewController.h"
#import <FIRAuth.h>
#import "PureLayout/PureLayout.h"
#import "Post.h"
#import "PostCell.h"
#import "TimelineViewController.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UIButton *confirmButton;
@property(strong, nonatomic) NSArray *categories;
@property(strong, nonatomic) NSMutableArray *selectedCategories;
@property(strong, nonatomic) NSMutableArray *filteredData;
@property(strong, nonatomic) NSArray *postsArray;

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
    UIView *superView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    superView.backgroundColor = UIColor.flatWhiteColor;
    [self.view addSubview:superView];
    
    [self configureTableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self configureCategoriesArray];
    [self allPostsButton];
    [self createBackButton];
    
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
    self.tableView.backgroundColor = UIColor.flatWhiteColor;
    self.view.backgroundColor = [UIColor blueColor];
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
    self.categories= @[@"Arts", @"Cinema", @"Concert", @"Eating", @"Festival", @"Fitness", @"Games", @"Networking", @"Outdoors", @"Partying", @"Shopping", @"Sports",  @"Other"];
    return self.categories;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FilterCell *cell =[tableView dequeueReusableCellWithIdentifier:@"filterCellIdentifier" forIndexPath:indexPath];
    cell.textLabel.textColor = UIColor.blackColor;
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.frame = CGRectMake(110, 0, 120, 30);
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.borderWidth = 2;
    confirmButton.layer.borderColor = UIColor.flatPinkColor.CGColor;
    [confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmButton setTitleColor:UIColor.flatSkyBlueColor forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(didTapConfirm) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmButton];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100.0f;
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
    for (NSString *chosenActivity in self.selectedCategories) {
        for (Post *post in self.postsArray) {
             NSString *activity = [Post activityTypeToString:post.activityType];
            if ([activity isEqualToString:chosenActivity]) {
                [self.filteredData addObject:post];
            }
        }
    }
    [self.filterDelegate filteredArray:self.filteredData];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didTapAllPosts {
    FIRDatabaseReference * ref =[[FIRDatabase database] reference];
    FIRDatabaseHandle handle = [[ref child:@"Posts"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postsDict = snapshot.value;
        NSArray *allPostsArray= [Post readPostsFromFIRDict:postsDict];
        [self.filterDelegate filteredArray:allPostsArray];
    }];
    [self dismissViewControllerAnimated:NO completion:nil];
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

- (instancetype)initWithArray:(NSArray *)array {
    self = [super init];
    self.postsArray = array;
    return self;
}


@end
