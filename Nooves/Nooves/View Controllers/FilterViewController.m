//
//  FilterViewController.m
//  Nooves
//
//  Created by Nikki Tran on 7/19/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "FilterViewController.h"
#import "PureLayout/PureLayout.h"

@interface FilterViewController ()
@property(strong, nonatomic) NSArray *labelsArray;
@end

@implementation FilterViewController
{
    UIButton *button;
    UILabel *label;
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
    int by = 110;
    
    for (int i = 0; i < 12; i ++) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(30, y, 50, 20)];
        label.text = self.labelsArray[i];
        [label sizeToFit];
        [self.view addSubview:label];
        
        button = [[UIButton alloc]initWithFrame:CGRectMake(150, by, 15, 15)];
        [button setImage:[UIImage imageNamed:@"unchecked-box"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"checked-box"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(checkedBox) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        y += 30;
        by += 30;
    }
    
    UIButton *confirmButton = [[UIButton alloc]init];
    [confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmButton sizeToFit];;
    [confirmButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:confirmButton];
    [confirmButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label withOffset:30];
    [confirmButton addTarget:self action:@selector(didTapConfirm) forControlEvents:UIControlEventTouchUpInside];
}

- (void)checkedBox {
    if(button.isSelected) {
        button.selected = NO;
    }
    else {
        button.selected = YES;
    }
}

- (void) didTapConfirm {
    // TODO: go back to the feed controller with filtered data
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
