//
//  LoginViewController.m
//  Nooves
//
//  Created by Nkenna Aniedobe on 7/24/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "LoginViewController.h"
#import <FirebaseAuth.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TimelineViewController.h"
@interface LoginViewController ()
@property UITextField *phoneNumber;
@property FIRUser *user;
@end

@implementation LoginViewController

- (void)viewDidLoad {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(UIButton *)selectDate {
//    UIButton *selectDate = [UIButton buttonWithType:UIButtonTypeSystem];
//    UIImage *calendarIcon = [UIImage imageNamed:@"calendar"];
//    [selectDate setImage:calendarIcon forState:UIControlStateNormal];
//    [selectDate addTarget:self action:@selector(didSelectDate) forControlEvents:UIControlEventTouchUpInside];
//    selectDate.center = CGPointMake(0, 300);
//    [selectDate sizeToFit];
//    return selectDate;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
