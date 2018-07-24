//
//  FilterViewController.m
//  Nooves
//
//  Created by Nikki Tran on 7/19/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "ComposeViewController.h"
#import "FilterViewController.h"
#import "PureLayout/PureLayout.h"
#import "TimelineViewController.h"

@interface FilterViewController ()
@property(strong, nonatomic) NSArray *labelsArray;
@property(strong, nonatomic) NSMutableArray *buttonsArray;
@property(strong, nonatomic) NSMutableArray *tempPosts;
@end

@implementation FilterViewController
{
    UIButton *checkboxButton;
    UILabel *tagLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupCategories];
}

- (void) setupCategories {
    // set up the date field
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.labelsArray = @[@"Outdoors", @"Shopping", @"Partying", @"Eating",@"Arts", @"Sports", @"Networking", @"Fitness", @"Games", @"Concert", @"Cinema", @"Festival"];
    int y = 100;
    int by = 100;
    self.buttonsArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 12; i++) {
        tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, y, 50, 20)];
        tagLabel.text = self.labelsArray[i];
        [tagLabel sizeToFit];
        [self.view addSubview:tagLabel];
        
        checkboxButton = [[UIButton alloc]initWithFrame:CGRectMake(150, by, 15, 15)];
        checkboxButton.tag = i;
        [self.buttonsArray addObject:checkboxButton];
        [checkboxButton setImage:[UIImage imageNamed:@"unchecked-box"] forState:UIControlStateNormal];
        [self.view addSubview:checkboxButton];

        y += 30;
        by += 30;
        }
    
    /*for (int i = 0; i < 12; i++) {
        if (checkboxButton.tag == i) {
            [checkboxButton setImage:[UIImage imageNamed:@"checked-box"] forState:UIControlStateSelected];
            [checkboxButton addTarget:self action:@selector(checkedBox) forControlEvents:UIControlEventTouchUpInside];
        }
    }*/
   
    
    NSLog(@"Buttons array: %@", self.buttonsArray);
    UIButton *confirmButton = [[UIButton alloc]init];
    [confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmButton sizeToFit];;
    [confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:confirmButton];
    [confirmButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:tagLabel withOffset:30];
    [confirmButton addTarget:self action:@selector(didTapConfirm) forControlEvents:UIControlEventTouchUpInside];
}


- (void) checkedBox {
    if(checkboxButton.isSelected) {
        checkboxButton.selected = NO;
    }
    else {
        checkboxButton.selected = YES;
    }
}

- (void) didTapConfirm {
    // TODO: go back to the feed controller with filtered data
    // associate each button tag with its label tag -- put the labels.text in an array
    // iterate through the array of posts
    // for each post that contains one or more strings listed in the array of checked buttons
    // add it to the array of new posts that will be displayed
    
    TimelineViewController *feed = [[TimelineViewController alloc]init];
    self.tempPosts = feed.tempPostsArray;
    for (id post in _tempPosts) {
        NSString *test = @"hello";
        if ([post containsString:test])  {
            NSLog(@"contains string");
        }
    }
    [self.navigationController pushViewController:feed animated:YES];
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

@end
