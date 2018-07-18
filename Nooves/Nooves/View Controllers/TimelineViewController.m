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


@interface TimelineViewController ()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *postsArray;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView = [self configureTableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.view addSubview:self.tableView];
    [self.tableView reloadData];

    self.navigationItem.title = @"Home";

    [self writeNewPost];

    // UIBarButtonItem *C
    //[self configureComposeButton];

}

- (UITableView *) configureTableView {
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    CGRect tableViewFrame = CGRectMake( x, y, width, height);

    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];

    self.tableView.rowHeight = 45;
    self.tableView.sectionFooterHeight = 22;
    self.tableView.sectionHeaderHeight = 22;
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.bounces = YES;

    return self.tableView;

}

- (UIBarButtonItem *) writeNewPost {

    UIBarButtonItem *composeButton = [[UIBarButtonItem alloc] init];
    composeButton.title = @"New Post";
    self.navigationItem.rightBarButtonItem = composeButton;

    composeButton.target = self;
    composeButton.action = @selector(didTapCompose);

    return composeButton;
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

- (void) didTapCompose {
    NSLog(@"pressed the compose button");
    ComposeViewController *test = [[ComposeViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

   // cell.textLabel.text = @"post";
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.postsArray.count;
}



@end
