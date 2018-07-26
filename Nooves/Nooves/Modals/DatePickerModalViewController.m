#import "ComposeViewController.h"
#import "DatePickerModalViewController.h"

@interface DatePickerModalViewController()

@end

@implementation DatePickerModalViewController

- (void)viewDidLoad {
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
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillAppear: (BOOL)animated {
    self.hidesBottomBarWhenPushed = YES;
}

- (UIButton *)selectDate {
    UIButton *selectDate = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectDate setTitle:@"Select Date" forState:UIControlStateNormal];
    [selectDate addTarget:self action:@selector(didSelectDate) forControlEvents:UIControlEventTouchUpInside];
    [selectDate sizeToFit];
    return selectDate;
}

- (void)didSelectDate {
    ComposeViewController *composer = [ComposeViewController new];
    self.date = [[NSDate alloc] init];
    self.date = self.datepicker.date;
    composer.date = self.date;
    composer.activityType = self.activityType;
    composer.lat = self.lat;
    composer.lng = self.lng;
    composer.location = self.location;
    [self.navigationController popViewControllerAnimated:YES];
    // [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}

- (void)didReceiveMemoryWarning {
}

@end
