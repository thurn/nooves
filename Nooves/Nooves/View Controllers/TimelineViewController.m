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
//#import "Post.h"


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
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = [UIColor whiteColor];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"testIdentifier"];
  
    [self.view addSubview:tableView];
    [tableView reloadData];

    self.navigationItem.title = @"Home";
    [self writeNewPost];
    [self filterResults];
    
    // set up the search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 44)];
   // [[self tableView] setTableHeaderView:searchBar];


}

- (UITableView *) configureTableView {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake( x, y, width, height);

    tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];

    tableView.rowHeight = 45;
    tableView.sectionFooterHeight = 22;
    tableView.sectionHeaderHeight = 22;
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    tableView.bounces = YES;

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
    self.navigationItem.leftBarButtonItem = filterButton;
    
    filterButton.target = self;
    filterButton.action = @selector(didTapFilter);
    
    return filterButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    postCell *cell = (postCell *)
    [tableView dequeueReusableCellWithIdentifier:@"testIdentifier" forIndexPath:indexPath];
    Post *newPost =self.postsArray[indexPath.row];
    //[cell setPost:newPost];
        cell = [[postCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:postcellIdentifier];
    
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 30;
}

- (void) didTapCompose {
    NSLog(@"pressed the compose button");
    ComposeViewController *test = [[ComposeViewController alloc] init];
    test.tempPostsArray = self.tempPostsArray;
    [self.navigationController pushViewController:test animated:YES];
}

- (void) didTapFilter {
    NSLog(@"clicked on the menu button");
    
    // implement a slide out menu bar
}

-(void) didTapProfile {
    NSLog(@"did tap on profile");
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profile animated:YES];
}


/*-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
*/


@end
