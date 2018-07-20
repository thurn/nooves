//
//  CategoryPickerPopUpViewController.m
//  Nooves
//
//  Created by Nikki Tran on 7/19/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "CategoryPickerPopUpViewController.h"
#import "ComposeViewController.h"

@interface CategoryPickerPopUpViewController () <UIPickerViewDataSource, UIPickerViewDelegate>


@end

@implementation CategoryPickerPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // need to remove and replace with enums for array
    self.categories = @[@"Outdoors", @"Shopping", @"Partying", @"Eating", @"Arts", @"Sports", @"Networking", @"Fitness", @"Games", @"Concert", @"Cinema", @"Festival", @"Other"];
    Post *post = [[Post alloc] init];
    NSLog(@"%ld", (long)post.activityType);
    // self.categoriesArray = [NSMutableArray arrayWithObject:[NSString post.ActivityType]];
    // self.categoriesArray = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:NS_ENUM(<#...#>)], nil];
    NSNumber *activities = @(post.activityType);
    NSMutableArray *list = [[NSMutableArray alloc] initWithObjects:activities, nil];
    for(id element in list) {
        NSLog(@"%@", [element description]);
    }

    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    
    self.categoryLabel = [[UILabel alloc] init];
    self.categoryLabel.frame = CGRectMake(10, 500, 100, 100);
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.categoryLabel];
    
    UIButton *selectedCategory = [self selectCategory];
    selectedCategory.frame = CGRectMake(10.0, 250.0, 20, 30);
    [selectedCategory sizeToFit];
    [self.view addSubview:selectedCategory];
}

-(UIButton *)selectCategory{
    UIButton *selectCategory = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectCategory setTitle:@"Select category" forState:UIControlStateNormal];
    [selectCategory addTarget:self action:@selector(didTapSelectCategory) forControlEvents:UIControlEventTouchUpInside];
    [selectCategory sizeToFit];
    return selectCategory;
}

-(void)didTapSelectCategory{
    ComposeViewController *composer = [[ComposeViewController alloc] init];
    composer.tempPostsArray = self.tempPostsArray;
    composer.date = self.date;
    
    [self.navigationController pushViewController:composer animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return self.categories.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.categories[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.categoryLabel.text = self.categories[row];
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
