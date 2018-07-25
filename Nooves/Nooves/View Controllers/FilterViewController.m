//
//  FilterViewController.m
//  Nooves
//
//  Created by Nikki Tran on 7/19/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

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
@property(strong, nonatomic) NSMutableArray *tempPostsArrayCopy;

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
    
    self.tempPostsArrayCopy = [[NSMutableArray alloc]init];
    for (Post *post in self.tempPostsArray) {
        [self.tempPostsArrayCopy addObject:post];
    }
    
    [self configureTableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self configureArray];
    [self configureButton];
    [self returnAllPosts];
    
    [self.tableView registerClass:[FilterCell class] forCellReuseIdentifier:@"filterCellIdentifier"];
    
    [self.tableView reloadData];
}

- (UITableView *)configureTableView {
    x = 0;
    y = 0;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake( x, y, width, height);
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.userInteractionEnabled = YES;
    [self.view addSubview:self.tableView];
    
    return self.tableView;
}

- (UIBarButtonItem *)returnAllPosts {
    allPosts = [[UIBarButtonItem alloc]init];
    allPosts.title = @"All Posts";
    self.navigationItem.rightBarButtonItem = allPosts;
    
    allPosts.target = self;
    allPosts.action = @selector(didTapAllPosts);
    
    return allPosts;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)configureArray {
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

- (void)configureButton {
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

    for (Post *post in self.tempPostsArray) {
        for (NSString *activity in self.selectedCategories) {
            ActivityType tagType = [Post stringToActivityType:activity];
            if (post.activityType == tagType) {
                [self.filteredData addObject:post];
            }
        }
    }
    
    TimelineViewController *feed = [[TimelineViewController alloc]init];
    feed.tempPostsArray = self.filteredData;
    [self.navigationController pushViewController:feed animated:YES];
}

- (void)didTapAllPosts {
    TimelineViewController *timeline = [[TimelineViewController alloc]init];
    timeline.tempPostsArray = self.tempPostsArrayCopy;
    [self.navigationController pushViewController:timeline animated:YES];
}

@end
