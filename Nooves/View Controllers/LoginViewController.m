#import "LoginViewController.h"
#import <FirebaseAuth.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TimelineViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "TabBarController.h"

#import "UIColor+Chameleon.h"
#import <ChameleonFramework/Chameleon.h>

@interface LoginViewController () <FBSDKLoginButtonDelegate>
@property UITextField *phoneNumber;
@property FIRUser *user;
@property (nonatomic) UITextField *usernameField;
@property (nonatomic) UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [FIRAuth auth].currentUser;
    
    NSArray *colors = [NSArray arrayWithObjects:FlatPink, FlatSkyBlue, nil];
    self.view.backgroundColor = GradientColor(UIGradientStyleTopToBottom, self.view.frame, colors);
    
    UILabel *nooves = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-30, 120, 50, 5)];
    nooves.text = @"Nooves";
    [nooves sizeToFit];
    [self.view addSubview:nooves];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    loginButton.readPermissions = @[@"public_profile", @"email"];
    loginButton.center = self.view.center;
    loginButton.frame = CGRectMake(self.view.bounds.size.width/6, 150, 250, 30);
    
    UILabel *or = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-5, 190, 5, 5)];
    or.text = @"or";
    [or sizeToFit];
    [self.view addSubview:or];

    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/6, 220, 250, 30)];
    self.usernameField.text = nil;
    self.usernameField.placeholder = @"Email or username";
    self.usernameField.borderStyle = UITextBorderStyleNone;
    self.usernameField.tintColor = [UIColor flatGrayColor];
    self.usernameField.backgroundColor = [UIColor clearColor];
    self.usernameField.layer.borderColor = [UIColor flatGrayColor].CGColor;
    self.usernameField.layer.borderWidth = 2.0f;
    self.usernameField.layer.cornerRadius = 3.0f;
    [self.view addSubview:self.usernameField];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/6, 260, 250, 30)];
    self.passwordField.text = nil;
    self.passwordField.placeholder = @"Password";
    self.passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordField.tintColor = [UIColor flatGrayColor];
    self.passwordField.backgroundColor = [UIColor clearColor];
    self.passwordField.layer.borderColor = [UIColor flatGrayColor].CGColor;
    self.passwordField.layer.borderWidth = 2.0f;
    self.passwordField.layer.cornerRadius = 3.0f;
    [self.view addSubview:self.passwordField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/6, 620, 20, 5)];
    label.text = @"Don't have an account? Sign up.";
    [label sizeToFit];
    [self.view addSubview:label];
    
    [self.view addSubview:loginButton];
    [self.view addSubview:[self createLoginButton]];
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
                                                     FIRUser *user = authResult.user;
                                                     self.user = user;
                                                     ProfileViewController* profileViewController = [[ProfileViewController alloc] init];
                                                     TimelineViewController *loginController = [[TimelineViewController alloc] init];
                                                     
                                                     UITabBarController *tabBarController = [[UITabBarController alloc] init];
                                                     
                                                     UINavigationController *timelineNavCont = [[UINavigationController alloc] initWithRootViewController:loginController];
                                                     UINavigationController *profileNavCont = [[UINavigationController alloc] initWithRootViewController:profileViewController];

                                                     tabBarController.viewControllers = @[timelineNavCont, profileNavCont];
     
                                                     UIImage *feedImage = [UIImage imageNamed:@"home"];
                                                     UIImage *profileImage = [UIImage imageNamed:@"profile"];
                                                     
                                                     loginController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:feedImage tag:0];
                                                     profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:profileImage tag:1];
                                                     [self presentViewController:tabBarController animated:NO completion:^{
                                                     }];
                                                 }];
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)createLoginButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(self.view.bounds.size.width, 300, 250, 30);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button setTitle:@"Login" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor flatSkyBlueColor]];
    return button;
}

- (void)didTapLogin {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    if ([self.usernameField.text isEqual:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"No username inserted"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *usernameAlert = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                              }];
        [alert addAction:usernameAlert];
        [self presentViewController:alert animated:YES completion:^{
        }];
        
    } else if ([self.passwordField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"No password inserted"
                                                                preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction *passwordAlert = [UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                              }];
        [alert addAction:passwordAlert];
        
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

@end
