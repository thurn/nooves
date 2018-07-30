#import "AppDelegate.h"
#import "ComposeViewController.h"
#import "TimelineViewController.h"
#import "TabBarController.h"
#import "ProfileViewController.h"
#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FirebaseAuth.h>
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
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    // Add any custom logic here.
    return handled;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [FIRApp configure];
    
    // the leaf controllers
    ProfileViewController* profileViewController = [[ProfileViewController alloc] init];
    LoginViewController *loginController = [[LoginViewController alloc] init];
    
    UINavigationController *timelineNavCont = [[UINavigationController alloc] initWithRootViewController:loginController];
    UINavigationController *profileNavCont = [[UINavigationController alloc] initWithRootViewController:profileViewController];
    
    TabBarController *tabBarController = [[TabBarController alloc] init];
    tabBarController.viewControllers = @[timelineNavCont, profileNavCont];
    
    UIImage *feedImage = [UIImage imageNamed:@"feed_tab"];
    UIImage *profileImage = [UIImage imageNamed:@"profile_tab"];
    
    loginController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:feedImage tag:0];
    profileViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:profileImage tag:1];
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
