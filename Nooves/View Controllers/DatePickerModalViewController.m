#import "DatePickerModalViewController.h"

@interface DatePickerModalViewController()
@end

@implementation DatePickerModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.datepicker = [[UIDatePicker alloc] init];
    self.datepicker.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
    self.datepicker.timeZone = [NSTimeZone localTimeZone];
    self.datepicker.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.datepicker];
    [self createBackButton];
    [self createConfirmButton];
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
    [self.dateDelegate datePickerModalViewController:self didPickDate:self.datepicker.date];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
