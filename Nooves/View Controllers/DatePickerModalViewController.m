#import "DatePickerModalViewController.h"

#import "FSCalendar.h"

@interface DatePickerModalViewController() <FSCalendarDelegate, FSCalendarDataSource>
@property (nonatomic, weak) FSCalendar *calendar;
@property (nonatomic) NSCalendar *gregorian;
@property (nonatomic) UIDatePicker *datepicker;
@end

@implementation DatePickerModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.datepicker = [[UIDatePicker alloc] init];
    self.datepicker.frame = CGRectMake(0, 300, self.view.frame.size.width, 200);
    self.datepicker.timeZone = [NSTimeZone localTimeZone];
    self.datepicker.backgroundColor = [UIColor whiteColor];
    self.datepicker.datePickerMode = UIDatePickerModeTime;
    
    [self.view addSubview:self.datepicker];
    [self createBackButton];
    [self createConfirmButton];
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    calendar.dataSource = self;
    calendar.delegate = self;
    self.calendar = calendar;
    self.calendar.appearance.todayColor = [UIColor yellowColor];
    [self.view addSubview:calendar];

    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    NSDateComponents *components = [self.gregorian components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger month = [components month];
    NSInteger day = [components day];
    self.selectedDate = [self.gregorian dateByAddingComponents:components toDate:self.datepicker.date options:0];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMM dd hh:mm a";
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateDetails = [formatter stringFromDate:self.selectedDate];
    NSLog(@"%@", dateDetails);
}

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};

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

// confirm button
- (UIBarButtonItem *)createConfirmButton {
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(didTapConfirmButton)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    return confirmButton;
}

// passes post data and jumps back to composer view controller
- (void)didTapConfirmButton {
    [self.dateDelegate datePickerModalViewController:self didPickDate:self.selectedDate];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
