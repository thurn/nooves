#import "AppDelegate.h"
#import "ComposeViewController.h"
#import "TimelineViewController.h"
#import "TabBarController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FirebaseAuth.h>
#import <Firebase/Firebase.h>

@import Firebase;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                           annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    return handled;
}

- (void)getCurrentLocation {
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [FIRApp configure];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    // the leaf controllers
    ProfileViewController* profileViewController = [[ProfileViewController alloc] init];
    TimelineViewController *loginController = [[TimelineViewController alloc] init];
    
    UINavigationController *timelineNavCont = [[UINavigationController alloc] initWithRootViewController:loginController];
    UINavigationController *profileNavCont = [[UINavigationController alloc] initWithRootViewController:profileViewController];

    TabBarController *tabBarController = [[TabBarController alloc] init];
    tabBarController.viewControllers = @[timelineNavCont, profileNavCont];
    
    UIImage *feedImage = [UIImage imageNamed:@"home"];
    UIImage *profileImage = [UIImage imageNamed:@"profile"];
    
    loginController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:feedImage tag:0];
    profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:profileImage tag:1];
    LoginViewController *login = [[LoginViewController alloc] init];
    UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:login];
    
    if (![FIRAuth auth].currentUser) {
        self.window.rootViewController = loginNav;
    }
    else {
        self.window.rootViewController = tabBarController;
    }
    [self.window makeKeyAndVisible];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

@end
