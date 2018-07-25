#import "ComposeViewController.h"
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
    UIButton *selectedDate = [self selectDate];
    selectedDate.frame = CGRectMake(10.0, 250.0, 20, 30);
    [selectedDate sizeToFit];
    [self.view addSubview:selectedDate];
    self.datepicker.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.datepicker];

}

- (UIButton *)selectDate{
    UIButton *selectDate = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectDate setTitle:@"Select Date" forState:UIControlStateNormal];
    [selectDate addTarget:self action:@selector(didSelectDate) forControlEvents:UIControlEventTouchUpInside];
    [selectDate sizeToFit];
    return selectDate;
}

- (void)didSelectDate{
    ComposeViewController *composer = [ComposeViewController new];
    composer.tempPostsArray = self.tempPostsArray;
    self.date = [[NSDate alloc] init];
    self.date = self.datepicker.date;
    composer.date = self.date;
    composer.activityType = self.activityType;
    [self.navigationController pushViewController:composer animated:YES];
}

- (void)didReceiveMemoryWarning{
}

@end
