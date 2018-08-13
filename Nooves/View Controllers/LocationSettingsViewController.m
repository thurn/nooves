#import "LocationSettingsViewController.h"

#import <FlatUIKit/UIColor+FlatUI.h>
#import "UIFont+FlatUI.h"


@interface LocationSettingsViewController () <UITextFieldDelegate>
@property (nonatomic) UISwitch *locationSwitch;
@property (nonatomic) UITextField *cityTextField;
@property (nonatomic) UITextField *stateTextField;
@property (nonatomic) UIButton *confirmButton;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *state;
@end

@implementation LocationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 15, 5)];
    label.text = @"Manually set location";
    [label sizeToFit];
    [self.view addSubview:label];
    
    self.cityTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 500, 30)];
    self.cityTextField.text = nil;
    self.cityTextField.placeholder = @"Enter city";
    self.cityTextField.borderStyle = UITextBorderStyleNone;
    self.cityTextField.textColor = UIColor.grayColor;
    [self.cityTextField setHidden:YES];
    
    self.stateTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 500, 30)];
    self.stateTextField.text = nil;
    self.stateTextField.placeholder = @"Enter state ex: CA";
    self.stateTextField.borderStyle = UITextBorderStyleNone;
    self.stateTextField.textColor = UIColor.grayColor;
    [self.stateTextField setHidden:YES];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.confirmButton.frame = CGRectMake(7, 110, 100, 100);
    [self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.confirmButton addTarget:self
                           action:@selector(didTapConfirm)
                 forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.hidden = YES;
    [self.confirmButton sizeToFit];
    
    CGRect myFrame = CGRectMake(170.0f, 0.0f, 250.0f, 25.0f);
    self.locationSwitch = [[UISwitch alloc] initWithFrame:myFrame];
    [self.locationSwitch setOn:NO];
    self.locationSwitch.on = [NSUserDefaults.standardUserDefaults boolForKey:@"switch"];
    [self.locationSwitch addTarget:self
                            action:@selector(switchToggled)
                  forControlEvents:UIControlEventValueChanged];
    if ([self.locationSwitch isOn]) {
        self.confirmButton.hidden = NO;
        [self.stateTextField setHidden:NO];
        [self.cityTextField setHidden:NO];
    }
    
    [self.view addSubview:self.cityTextField];
    [self.view addSubview:self.stateTextField];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.locationSwitch];
    [self createBackButton];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.cityTextField.text == nil) {
        self.cityTextField.text = @"Enter city";
    } else {
        self.cityTextField.text = [NSUserDefaults.standardUserDefaults objectForKey:@"city"];
    }
    
    if (self.stateTextField.text == nil) {
        self.stateTextField.text = @"Enter state ex: CA";
    } else {
        self.stateTextField.text = [NSUserDefaults.standardUserDefaults objectForKey:@"state"];
    }
}

- (void)switchToggled {
    [NSUserDefaults.standardUserDefaults setBool:self.locationSwitch.on forKey:@"switch"];
    if ([self.locationSwitch isOn]) {
        NSLog(@"Switch activated");
        [self.stateTextField setHidden:NO];
        [self.cityTextField setHidden:NO];
        self.confirmButton.hidden = NO;
        
    } else {
        NSLog(@"Switch unactivated");
        [self.stateTextField setHidden:YES];
        [self.cityTextField setHidden:YES];
        self.confirmButton.hidden = YES;
    }
}

- (UIButton *)createConfirmButton {
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    confirmButton.frame = CGRectMake(7, 110, 100, 100);
    [confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmButton addTarget:self
                      action:@selector(didTapConfirm)
            forControlEvents:UIControlEventTouchUpInside];
    [confirmButton sizeToFit];
    return confirmButton;
}

- (void)didTapConfirm {
    self.city = self.cityTextField.text;
    self.state = self.stateTextField.text;
    [NSUserDefaults.standardUserDefaults setObject:self.city forKey:@"city"];
    [NSUserDefaults.standardUserDefaults setObject:self.state forKey:@"state"];
}

// sets up back button properties
- (UIBarButtonItem *)createBackButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back-icon"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(didTapBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    return backButton;
}

// jumps back to root view controller
- (void)didTapBackButton {
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Text Field methods

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.textColor == UIColor.grayColor) {
        textField.text = nil;
        textField.textColor = UIColor.blackColor;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.text == nil) {
        textField.textColor = UIColor.grayColor;
    }
}

@end
