//
//  EventsViewController.m
//  Nooves
//
//  Created by Norette Ingabire on 8/1/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "EventCell.h"
#import "EventsViewController.h"

static NSString * const baseURLString = @"http://api.eventful.com/json/events/search?";
static NSString * const appKey = @"dFXh3rhZVVwbshg9";
static NSString * const consumerKey = @"5db85641372af05aa023";
static NSString * const consumerSecret = @"93767e5098b45988d73f";

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property(strong, nonatomic) NSArray *eventsArray;
@property(strong, nonatomic) UISearchBar *searchBar;

@end

@implementation EventsViewController {
    UITableView *tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [self configureTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView *)configureTableView {
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake( 0, 0, width, height);
    
    tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    tableView.scrollEnabled = YES;
    tableView.showsVerticalScrollIndicator = YES;
    tableView.userInteractionEnabled = YES;
    [self.view addSubview:tableView];
    
    // set up the search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(-5.0, 0.0, 320.0, 44.0)];
    self.searchBar.delegate = self;
    self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 310.0, 44.0)];
    searchBarView.autoresizingMask = 0;
    [searchBarView addSubview:self.searchBar];
    self.navigationItem.titleView = searchBarView;
    
    return tableView;
}

#pragma mark - UITableViewDelegate methods
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCellIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = self.eventsArray[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.eventsArray.count;
}

#pragma mark - UISearchBarDelegate methods
// cancel button appears when user edits search bar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

// will delete search text when cancel button clicked
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}


@end
