#import "DatePickerModalViewController.h"

#import "FSCalendar.h"

@interface DatePickerModalViewController() <FSCalendarDelegate, FSCalendarDataSource>
@property (nonatomic, weak) FSCalendar *calendar;
@property (nonatomic) NSCalendar *gregorian;
@property (nonatomic) UIDatePicker *datepicker;
@property (nonatomic) UIDatePickerMode *datePickerMode;
@end

@implementation DatePickerModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    self.datepicker = [[UIDatePicker alloc] init];
    self.datepicker.frame = CGRectMake(0, 300, self.view.frame.size.width, 200);
    self.datepicker.timeZone = [NSTimeZone localTimeZone];
//    self.datepicker.calendar = self.gregorian;
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

}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    
    NSDateComponents *components = [self.gregorian components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSDateFormatter *output = [[NSDateFormatter alloc] init];
    [output setDateFormat:@"MMM dd "];
    
    NSDate *yeet = self.datepicker.date;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:yeet];
    NSInteger hour = [comp hour];
    NSInteger min = [comp minute];
    
    NSDateFormatter *output2 = [[NSDateFormatter alloc] init];
    [output2 setDateFormat:@"hh:mm a"];
    
//    NSString *string = [output2 stringFromDate:self.datepicker.date];
//    NSDate *dateFromString = [output2 dateFromString:string];
    
    self.selectedDate = [NSDate new];
    self.selectedDate = [self.gregorian dateBySettingUnit:(NSCalendarUnitMonth) value:month ofDate:self.selectedDate options:0];
    self.selectedDate = [self.gregorian dateBySettingUnit:(NSCalendarUnitDay) value:day ofDate:self.selectedDate options:0];
    self.selectedDate = [self.gregorian dateBySettingUnit:(NSCalendarUnitHour) value:hour ofDate:self.selectedDate options:0];
    self.selectedDate = [self.gregorian dateBySettingUnit:(NSCalendarUnitMinute) value:min ofDate:self.selectedDate options:0];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MMM dd hh:mm a";
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *dateDetails = [formatter stringFromDate:self.selectedDate];
    //NSDate *help = [formatter dateFromString:dateDetails];
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
