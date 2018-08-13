#import "DatePickerModalViewController.h"

#import "FSCalendar.h"
#import <ChameleonFramework/Chameleon.h>

@interface DatePickerModalViewController() <FSCalendarDelegate, FSCalendarDataSource>
@property (nonatomic, weak) FSCalendar *calendar;
@property (nonatomic) NSCalendar *gregorian;
@property (nonatomic) UIDatePicker *datepicker;
@property (nonatomic) UIDatePickerMode *datePickerMode;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger hour;
@property (nonatomic) NSInteger minute;
@end

@implementation DatePickerModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor flatWhiteColor];
    self.selectedDate = [[NSDate alloc] init];
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    
    self.datepicker = [[UIDatePicker alloc] init];
    self.datepicker.frame = CGRectMake(0, 300, self.view.frame.size.width, 200);
    self.datepicker.timeZone = [NSTimeZone localTimeZone];
    self.datepicker.calendar = self.gregorian;
    self.datepicker.backgroundColor = [UIColor flatWhiteColor];
    self.datepicker.datePickerMode = UIDatePickerModeTime;
    
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    calendar.dataSource = self;
    calendar.delegate = self;
    self.calendar = calendar;
    self.calendar.appearance.todayColor = [UIColor flatPinkColor];
    self.calendar.appearance.selectionColor = [UIColor flatSkyBlueColor];
    self.calendar.appearance.headerTitleColor = [UIColor flatPinkColor];
    self.calendar.appearance.weekdayTextColor = [UIColor flatPinkColor];
    [[self.calendar appearance] setTitleFont:[UIFont fontWithName:@"ProximaNovaT-Thin" size:12.0]];
    [[self.calendar appearance] setSubtitleFont:[UIFont fontWithName:@"ProximaNovaT-Thin" size:12.0]];
    
    [self.view addSubview:calendar];
    [self.view addSubview:self.datepicker];
    [self createBackButton];
    [self createConfirmButton];
}

#pragma mark - FSCalendar Delegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    NSDateComponents *components = [self.gregorian components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    _month = [components month];
    _day = [components day];
}

#pragma mark - FSCalendar Data Source
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar {
    return [NSDate date];
}
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    calendar.frame = (CGRect) {
        calendar.frame.origin,bounds.size
    };
    
}

- (void)getTime {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comp = [cal components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.datepicker.date];
    _hour = [comp hour];
    _minute = [comp minute];
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
    [self getTime];
    
    self.selectedDate = [self.gregorian dateBySettingUnit:(NSCalendarUnitMonth) value:_month ofDate:self.selectedDate options:0];
    self.selectedDate = [self.gregorian dateBySettingUnit:(NSCalendarUnitDay) value:_day ofDate:self.selectedDate options:0];
    self.selectedDate = [self.gregorian dateBySettingUnit:(NSCalendarUnitHour) value:_hour ofDate:self.selectedDate options:0];
    self.selectedDate = [self.gregorian dateBySettingUnit:(NSCalendarUnitMinute) value:_minute ofDate:self.selectedDate options:0];
    
    [self.dateDelegate datePickerModalViewController:self didPickDate:self.selectedDate];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
