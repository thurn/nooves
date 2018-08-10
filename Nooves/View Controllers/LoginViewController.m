#import "LoginViewController.h"
#import <FirebaseAuth.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TimelineViewController.h"
#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "TabBarController.h"
@interface LoginViewController () <FBSDKLoginButtonDelegate>
@property UITextField *phoneNumber;
@property FIRUser *user;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.user = [FIRAuth auth].currentUser;
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.delegate = self;
    // Optional: Place the button in the center of your view.
    loginButton.readPermissions = @[@"public_profile", @"email"];
    loginButton.center = self.view.center;
    
    [self.view addSubview:loginButton];
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
                                                     
                                                     TabBarController *tabBarController = [[TabBarController alloc] init];
                                                    UINavigationController *tabBarNavCont = [[UINavigationController alloc] initWithRootViewController:tabBarController];
                                                     
                                                     UINavigationController *timelineNavCont = [[UINavigationController alloc] initWithRootViewController:loginController];
                                                     UINavigationController *profileNavCont = [[UINavigationController alloc] initWithRootViewController:profileViewController];

                                                     tabBarController.viewControllers = @[timelineNavCont, profileNavCont];
     
                                                     UIImage *feedImage = [UIImage imageNamed:@"home"];
                                                     UIImage *profileImage = [UIImage imageNamed:@"profile"];
                                                     
                                                     loginController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:feedImage tag:0];
                                                     profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:profileImage tag:1];
                                                     [self.navigationController presentViewController:tabBarNavCont animated:NO completion:nil];
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

@end
