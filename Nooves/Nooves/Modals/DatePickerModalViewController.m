#import "DatePickerModalViewController.h"

@interface DatePickerModalViewController()

@end

@implementation DatePickerModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.datepicker = [[UIDatePicker alloc]init];
    self.datepicker.frame = CGRectMake(10.0, 50.0, self.view.frame.size.width, 200);
    self.datepicker.timeZone = [NSTimeZone localTimeZone];
    self.datepicker.backgroundColor = [UIColor whiteColor];
    
    UIButton *selectedDate = [self selectDate];
    selectedDate.frame = CGRectMake(10.0, 300.0, 20, 30);
    [selectedDate sizeToFit];
    
    [self.view addSubview:selectedDate];
    [self.view addSubview:self.datepicker];
    [self createBackButton];
}

// hides tab bar
- (void)viewWillAppear: (BOOL)animated {
    self.hidesBottomBarWhenPushed = YES;
}

// user confirmatin button when date is selected
- (UIButton *)selectDate {
    UIButton *selectDate = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectDate setTitle:@"Select Date" forState:UIControlStateNormal];
    [selectDate addTarget:self
                   action:@selector(didSelectDate)
         forControlEvents:UIControlEventTouchUpInside];
    [selectDate sizeToFit];
    return selectDate;
}

// sends data to parent controller
- (void)didSelectDate {
    [self.dateDelegate datePickerModalViewController:self didPickDate:self.datepicker.date];
    [self dismissViewControllerAnimated:NO completion:nil];
}

// back button
- (UIBarButtonItem *)createBackButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back-icon"]
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                         action:@selector(didTapBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;
    return backButton;
}

// goes back to parent controller
- (void)didTapBackButton {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
