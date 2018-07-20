//
//  DatePickerPopUpViewController.m
//  Nooves
//
//  Created by Nkenna Aniedobe on 7/19/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "DatePickerPopUpViewController.h"

@interface DatePickerPopUpViewController()

@end
@implementation DatePickerPopUpViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.datepicker = [[UIDatePicker alloc]init];
    self.datepicker.frame = CGRectMake(10.0, 30.0, self.view.frame.size.width, 200);
    self.datepicker.timeZone = [NSTimeZone localTimeZone];
    self.datepicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.datepicker];
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
