//
//  TimelineViewController.m
//  Nooves
//
//  Created by Norette Ingabire on 7/17/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "TimelineViewController.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "postCell.h"
#import "ProfileViewController.h"
#import "PureLayout/PureLayout.h"
#import "FilterViewController.h"


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
    
    // Do any additional setup after loading the view.
    if(!self.tempPostsArray){
        self.tempPostsArray = [[NSMutableArray alloc]init];
    }
    
    tableView = [self configureTableView];
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    self.searchBar.delegate = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    [tableView reloadData];
    
    self.navigationItem.title = @"Home";
    [self writeNewPost];
    [self filterResults];
    
    [tableView registerClass:[postCell class] forCellReuseIdentifier:@"postCellIdentifier"];

    // set up the search bar
    // UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 44)];
    //[tableView setTableHeaderView:searchBar];
}

- (UITableView *) configureTableView {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake( x, y, width, height);

    tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;

    return tableView;
}

- (UIBarButtonItem *) writeNewPost {

    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] init];
    composeButton.title = @"New Post";
    self.navigationItem.rightBarButtonItem = composeButton;

    composeButton.target = self;
    composeButton.action = @selector(didTapCompose);

    return composeButton;
}

- (UIBarButtonItem *) filterResults {
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    postCell *cell =[tableView dequeueReusableCellWithIdentifier:@"postCellIdentifier" forIndexPath:indexPath];
    Post *newPost =self.tempPostsArray[indexPath.row];
    [cell configurePost:newPost];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.tempPostsArray){
        return self.tempPostsArray.count;
    }
    return 30;
}

- (void) didTapCompose {
    ComposeViewController *composer = [[ComposeViewController alloc] init];
    composer.hidesBottomBarWhenPushed = YES;
    composer.tempPostsArray = self.tempPostsArray;
    [self.navigationController pushViewController:composer animated:YES];
}

- (void) didTapFilter {
    FilterViewController *filter = [[FilterViewController alloc]init];
  //  filter.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:filter animated:YES];
    
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
            return  [evaluatedObject containsString:searchText];
        }];
        self.filtedData = [self.tempPostsArray filteredArrayUsingPredicate:predicate];
    }
    
    else {
        self.filtedData = self.tempPostsArray;
    }
    [tableView reloadData];
}

-(void) didTapProfile {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profile animated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
