//
//  TimelineViewController.m
//  Nooves
//
//  Created by Norette Ingabire on 7/17/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "TimelineViewController.h"

@interface TimelineViewController ()

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UILabel *label;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    self.navigationItem.title = @"Home";
    
    // Initialize a button
    UIButton *composeButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    composeButon.backgroundColor = [UIColor blueColor];
    
    composeButon.frame = CGRectMake(50.0f, 200.0f, 100.0f, 30.0f);
    
    [composeButon addTarget:self action:@selector(didTapCompose) forControlEvents:UIControlEventTouchUpInside];
    [composeButon setTitle:@"Compose" forState:UIControlStateNormal];
    [self.view addSubview:composeButon];
    
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
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.textLabel.text = @"post";
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    // REPLACE PLACEHOLDER
    return 1;
}



@end
