//
//  DatePickerPopUpViewController.m
//  Nooves
//
//  Created by Nkenna Aniedobe on 7/19/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "DatePickerPopUpViewController.h"
#import "ComposeViewController.h"
@interface DatePickerPopUpViewController()

@end
@implementation DatePickerPopUpViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.datepicker = [[UIDatePicker alloc]init];
    self.datepicker.frame = CGRectMake(10.0, 30.0, self.view.frame.size.width, 200);
    self.datepicker.timeZone = [NSTimeZone localTimeZone];
    UIButton *selectedDate = [self selectDate];
    selectedDate.frame = CGRectMake(10.0, 250.0, 20, 30);
    [selectedDate sizeToFit];
    [self.view addSubview:selectedDate];
    self.datepicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.datepicker];

}
-(UIButton *)selectDate{
    UIButton *selectDate = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectDate setTitle:@"Select Date" forState:UIControlStateNormal];
    [selectDate addTarget:self action:@selector(didSelectDate) forControlEvents:UIControlEventTouchUpInside];
    [selectDate sizeToFit];
    return selectDate;
}
-(void)didSelectDate{
    ComposeViewController *composer = [ComposeViewController new];
//    composer.tempPostsArray = self.tempPostsArray;
//    composer.date = self.datepicker.date;
    
    composer.tempPostsArray = self.tempPostsArray;
    self.date = composer.date;
    composer.activityType = self.activityType;
    [self.navigationController pushViewController:composer animated:YES];
}
- (void)didReceiveMemoryWarning{
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
