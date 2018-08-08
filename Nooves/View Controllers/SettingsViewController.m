#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FirebaseAuth.h>

#import "LoginViewController.h"
#import "SettingsViewController.h"

@interface SettingsViewController () <FBSDKLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic) UIButton *logout;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UISwitch *locationSwitch;
@property (nonatomic) UITextField *cityTextField;
@property (nonatomic) UITextField *stateTextField;
@property (nonatomic) UIButton *confirmButton;
@end

@implementation SettingsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 15, 5)];
    label.text = @"Manually set location";
    [label sizeToFit];
    [self.view addSubview:label];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    loginButton.readPermissions = @[@"public_profile", @"email"];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    
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
    [self.view addSubview:self.cityTextField];
    [self.view addSubview:self.stateTextField];
    
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.confirmButton.frame = CGRectMake(7, 110, 100, 100);
    [self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
    [self.confirmButton addTarget:self
                      action:@selector(didTapConfirm)
            forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.hidden = YES;
    [self.confirmButton sizeToFit];
    [self.view addSubview:self.confirmButton];
    
    
    CGRect myFrame = CGRectMake(170.0f, 0.0f, 250.0f, 25.0f);
    self.locationSwitch = [[UISwitch alloc] initWithFrame:myFrame];
    [self.locationSwitch setOn:NO];
    //self.locationSwitch.on = [NSUserDefaults.standardUserDefaults setBool:YES boolForKey:@"location"];
//    if (self.city == nil && self.state == nil) {
//        [self.locationSwitch setOn:YES];
//    }
    [self.locationSwitch addTarget:self
                            action:@selector(switchToggled)
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.locationSwitch];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (void)switchToggled {
    if ([_locationSwitch isOn]) {
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

- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
              error:(NSError *)error {
    if (error == nil) {
        FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                         credentialWithAccessToken:[FBSDKAccessToken currentAccessToken].tokenString];
        [[FIRAuth auth] signInAndRetrieveDataWithCredential:credential
                                                 completion:^(FIRAuthDataResult * _Nullable authResult,
                                                              NSError * _Nullable error) {
                                                     if (error) {
                                                         // ...
                                                         return;
                                                     }
                                                     // User successfully signed in. Get user data from the FIRUser object
                                                     if (authResult == nil) { return; }
                                                 }];
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

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

- (UIButton *)createConfirmButton{
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

@end
