#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FirebaseAuth.h>

#import "LoginViewController.h"
#import "SettingsViewController.h"

@interface SettingsViewController () <FBSDKLoginButtonDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UIButton *logout;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UISwitch *locationSwitch;
@property (nonatomic) UITextField *cityTextField;
@property (nonatomic) UITextField *stateTextField;
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
    
    self.stateTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 500, 30)];
    self.stateTextField.text = nil;
    self.stateTextField.placeholder = @"Enter state ex: CA";
    self.stateTextField.borderStyle = UITextBorderStyleNone;
    self.stateTextField.textColor = UIColor.grayColor;
    
    [self.view addSubview:self.cityTextField];
    [self.view addSubview:self.stateTextField];
    
    CGRect myFrame = CGRectMake(170.0f, 0.0f, 250.0f, 25.0f);
    self.locationSwitch = [[UISwitch alloc] initWithFrame:myFrame];
    [self.locationSwitch setOn:YES];
    [self.locationSwitch addTarget:self
                            action:@selector(switchToggled)
                  forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.locationSwitch];
}

- (void)switchToggled {
    if ([_locationSwitch isOn]) {
        NSLog(@"Switch activated");
    } else {
        NSLog(@"Switch unactivated");
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

@end
