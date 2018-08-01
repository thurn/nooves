#import "LoginViewController.h"
#import <FirebaseAuth.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TimelineViewController.h"
@interface LoginViewController ()<FBSDKLoginButtonDelegate>
@property UITextField *phoneNumber;
@property FIRUser *user;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.user = [FIRAuth auth].currentUser;
    if(self.user!=nil){
        [self.navigationController pushViewController:[TimelineViewController new] animated:YES];
    }
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
                                                     [self.navigationController pushViewController:[TimelineViewController new] animated:YES];
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
