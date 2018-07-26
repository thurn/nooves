//
//  TimelineViewController.m
//  Nooves
//
//  Created by Norette Ingabire on 7/17/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "AppDelegate.h"
#import "ComposeViewController.h"
#import "FilterViewController.h"
#import "PostCell.h"
#import "ProfileViewController.h"
#import "PureLayout/PureLayout.h"
#import "TimelineViewController.h"
#import <FIRDatabase.h>

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
    FIRDatabaseReference * ref =[[FIRDatabase database] reference];
    FIRDatabaseHandle *handle = [[ref child:@"Posts"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        self.postsDict = snapshot.value;
        for(NSString *key in self.postsDict){
            Post *posty = [[Post alloc]init];
            posty.fireBaseID = key;
            posty.activityTitle = self.postsDict[key][@"Title"];
            posty.activityDescription = self.postsDict[key][@"Description"];
            posty.userID = self.postsDict[key][@"User ID"];
            posty.activityLat = self.postsDict[key][@"Latitude"];
            posty.activityLng = self.postsDict[key][@"Longitude"];
            ActivityType type = [self.postsDict[key][@"Activity Type"] integerValue];
            posty.activityType = type;
            NSInteger date = [self.postsDict[key][@"Date"] integerValue];
            NSDate *daty = [NSDate dateWithTimeIntervalSince1970:date];
            posty.activityDateAndTime = daty;
            [tempArray addObject:posty];
        }
        self.firArray = [NSArray arrayWithArray:tempArray];
        [tableView reloadData];
    }];
    tableView = [self configureTableView];
    
    // Do any additional setup after loading the view.
    if(!self.tempPostsArray){
        self.tempPostsArray = [[NSMutableArray alloc]init];
    }

    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
    
    self.navigationItem.title = @"Home";
    [self writeNewPost];
    [self filterResults];
    
    [tableView registerClass:[PostCell class] forCellReuseIdentifier:@"postCellIdentifier"];

    // set up the search bar
    // UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 44)];
    //[tableView setTableHeaderView:searchBar];
}

- (UITableView *)configureTableView {
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
    ComposeViewController *composer = [[ComposeViewController alloc] init];
    composer.tempPostsArray = self.tempPostsArray;
    [self.navigationController pushViewController:composer animated:YES];
}

- (void)didTapFilter {
    FilterViewController *filter = [[FilterViewController alloc]init];
    filter.tempPostsArray = self.tempPostsArray;
    [self.navigationController pushViewController:filter animated:YES];
}

-(void)didTapProfile {
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self.navigationController pushViewController:profile animated:YES];
}

@end
