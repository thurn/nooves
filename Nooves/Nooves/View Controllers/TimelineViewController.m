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
//#import "postCell.h"


@interface TimelineViewController ()



@end

@implementation TimelineViewController

UIButton *interestedButton;
UIButton *goingButton;
bool going = NO;
bool interested = NO;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [self configureTableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.view addSubview:self.tableView];
    [self.tableView reloadData];

    self.navigationItem.title = @"Home";
    [self writeNewPost];
    [self itemsMenu];
    [self goingToEvent];
    [self interestedInEvent];
    
    // set up the search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 44)];
    [[self tableView] setTableHeaderView:searchBar];
    
    // set up the post field
    UILabel *postField = [[UILabel alloc] initWithFrame:CGRectMake(100,110,300, 30)];
    UIColor *postColor = [UIColor blueColor];
    [postField setBackgroundColor: postColor];
    [postField setText:@"Insert Post here"];
    [self.view addSubview:postField];
    
    
    //set up the date field
    UILabel *dateField = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 50 , 50)];
    UIColor *dateColor = [UIColor yellowColor];
    [dateField setBackgroundColor:dateColor];
    [dateField setText:@"Date"];
    [self.view addSubview:dateField];
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

- (UIBarButtonItem *) itemsMenu {
    
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] init];
    filterButton.title = @"Filter";
    self.navigationItem.leftBarButtonItem = filterButton;
    
    filterButton.target = self;
    filterButton.action = @selector(didTapFilter);
    
    return filterButton;
}

- (UIButton *) goingToEvent {
    
    goingButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 100, 30)];
    UIColor *goingButtonColor = [UIColor purpleColor];
    [goingButton setBackgroundColor:goingButtonColor];
    [goingButton setTitle:@"Going" forState:UIControlStateNormal];
    [self.view addSubview:goingButton];
    
    [goingButton addTarget:self action:@selector(didTapGoing) forControlEvents:UIControlEventTouchUpInside];
    
    return goingButton;
}

- (UIButton *) interestedInEvent {
    
   interestedButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 150, 100, 30)];
    UIColor *interestedButtonColor = [UIColor greenColor];
    [interestedButton setBackgroundColor:interestedButtonColor];
    [interestedButton setTitle:@"Interested" forState:UIControlStateNormal];
    [self.view addSubview:interestedButton];
    
    [interestedButton addTarget:self action:@selector(didTapInterested) forControlEvents:UIControlEventTouchUpInside];
    
    return interestedButton;
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.postsArray.count;
}

- (void) didTapCompose {
    NSLog(@"pressed the compose button");
    ComposeViewController *test = [[ComposeViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}

- (void) didTapFilter {
    NSLog(@"clicked on the menu button");
    
    // implement a slide out menu bar
}

- (void) didTapGoing {
     //  change button color and number/list of people going and check for unselected button
    if (!interested) {
        if (going) {
            NSLog(@"not going anymore");
            [goingButton setBackgroundColor:[UIColor purpleColor]];
            going = NO;
        }
        
        else {
            NSLog(@"TAPPED GOING BUTTON");
            UIColor *selectedGoing = [UIColor blackColor];
            [goingButton setBackgroundColor:selectedGoing];
            going = YES;
        }
    }
    
    else {
        interested = NO;
        [interestedButton setBackgroundColor:[UIColor greenColor]];
        if (going) {
            NSLog(@"not going anymore");
            [goingButton setBackgroundColor:[UIColor purpleColor]];
            going = NO;
        }
        
        else {
            NSLog(@"TAPPED GOING BUTTON");
            UIColor *selectedGoing = [UIColor blackColor];
            [goingButton setBackgroundColor:selectedGoing];
            going = YES;
        }
    }
}

- (void) didTapInterested {
    if (!going) {
        if (interested) {
            // DECREMENT THE NUMBER OF THOSE INTERESTED - REMOVE USER FROM THE LIST
            NSLog(@"Changed to not interested");
            [interestedButton setBackgroundColor:[UIColor greenColor]];
            interested = NO;
        }
        else {
            // ADD THE USER TO THE LIST OF THOSE INTERESTED
            NSLog(@"tapped interested button");
            UIColor *selectedInterested = [UIColor blackColor];
            [interestedButton setBackgroundColor:selectedInterested];
            interested = YES;
        }
    }
    
    else {
        going = NO;
        [goingButton setBackgroundColor:[UIColor purpleColor]];
        if (interested) {
            // DECREMENT THE NUMBER OF THOSE INTERESTED - REMOVE USER FROM THE LIST
            NSLog(@"Changed to not interested");
            [interestedButton setBackgroundColor:[UIColor greenColor]];
            interested = NO;
        }
        else {
            // ADD THE USER TO THE LIST OF THOSE INTERESTED
            NSLog(@"tapped interested button");
            UIColor *selectedInterested = [UIColor blackColor];
            [interestedButton setBackgroundColor:selectedInterested];
            interested = YES;
        }
    }
}
@end
