#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FirebaseAuth.h>

#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "LocationSettingsViewController.h"
#import "PureLayout/PureLayout.h"
#import <ChameleonFramework/Chameleon.h>
#import "TabBarController.h"
@interface SettingsViewController () <FBSDKLoginButtonDelegate>
@property (nonatomic) UIButton *logout;
@end

@implementation SettingsViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor flatWhiteColor];
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    loginButton.readPermissions = @[@"public_profile", @"email"];
    loginButton.frame = CGRectMake(50, 470, 100, 100);
    [loginButton sizeToFit];
    
    int iterator = 0;
    for (int i = 0; i < 9; i++) {
        float xpos = 355;
        float ypos = 10 + iterator;
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"chevron-right", i]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xpos, ypos, 15, 15)];
        [imageView setImage:image];
        [self.view addSubview:imageView];
        iterator += 27;
    }
    
    [self.view addSubview:[self createInviteFriendsButton]];
    [self.view addSubview:[self createAccountButton]];
    [self.view addSubview:[self createNotificationsButton]];
    [self.view addSubview:[self createHelpCenterButton]];
    [self.view addSubview:[self createReportButton]];
    [self.view addSubview:[self createPrivacyButton]];
    [self.view addSubview:[self createAboutButton]];
    [self.view addSubview:[self createLocationButton]];
    [self.view addSubview:loginButton];
    
}

#pragma mark - log out

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
                                                     if (authResult == nil) { return; }
                                                     FIRUser *user = authResult.user;
                                                     ProfileViewController* profileViewController = [[ProfileViewController alloc] init];
                                                     TimelineViewController *loginController = [[TimelineViewController alloc] init];
                                                     
                                                     TabBarController *tabBarController = [[TabBarController alloc] init];
                                                     UINavigationController *tabBarNavCont = [[UINavigationController alloc] initWithRootViewController:tabBarController];
                                                     
                                                     UINavigationController *timelineNavCont = [[UINavigationController alloc] initWithRootViewController:loginController];
                                                     UINavigationController *profileNavCont = [[UINavigationController alloc] initWithRootViewController:profileViewController];
                                                     
                                                     tabBarController.viewControllers = @[timelineNavCont, profileNavCont];
                                                     
                                                     UIImage *feedImage = [UIImage imageNamed:@"home"];
                                                     UIImage *profileImage = [UIImage imageNamed:@"profile"];
                                                     
                                                     loginController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:feedImage tag:0];
                                                     profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:profileImage tag:1];
                                                     [self.navigationController presentViewController:tabBarController animated:NO completion:nil];
                                                 }];
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    [self.navigationController presentViewController:[LoginViewController new] animated:YES completion:nil];
}

- (UIButton *)createInviteFriendsButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(5, 10, 100, 100);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button setImage:[UIImage imageNamed:@"invite-friends"] forState:UIControlStateNormal];
    [button setTitle:@"Invite friends" forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

- (UIButton *)createAccountButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(5, 40, 100, 100);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -12);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button setImage:[UIImage imageNamed:@"account"] forState:UIControlStateNormal];
    [button setTitle:@"Account" forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

- (UIButton *)createNotificationsButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(5, 70, 100, 100);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button setImage:[UIImage imageNamed:@"notifications"] forState:UIControlStateNormal];
    [button setTitle:@"Notifications" forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

- (UIButton *)createHelpCenterButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(5, 100, 100, 100);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -12);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button setImage:[UIImage imageNamed:@"help"] forState:UIControlStateNormal];
    [button setTitle:@"Help Center" forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

- (UIButton *)createReportButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(5, 130, 100, 100);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button setImage:[UIImage imageNamed:@"report"] forState:UIControlStateNormal];
    [button setTitle:@"Report a problem" forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

- (UIButton *)createPrivacyButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(5, 160, 100, 100);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button setImage:[UIImage imageNamed:@"privacy"] forState:UIControlStateNormal];
    [button setTitle:@"Privacy policy" forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

- (UIButton *)createAboutButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(5, 190, 100, 100);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -12);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    [button setTitle:@"About" forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

- (UIButton *)createLocationButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(5, 220, 100, 100);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -12);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTintColor:[UIColor blackColor]];
    [button setImage:[UIImage imageNamed:@"location-settings"] forState:UIControlStateNormal];
    [button setTitle:@"Location" forState:UIControlStateNormal];
    [button addTarget:self
                     action:@selector(didTapLocationButton)
           forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    return button;
}

- (void)didTapLocationButton {
    LocationSettingsViewController *controller = [[LocationSettingsViewController alloc] init];
    UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:controller];
    //[self.navigationController pushViewController:controller animated:YES];
    [self.navigationController presentViewController:navCont animated:YES completion:nil];
}

@end
