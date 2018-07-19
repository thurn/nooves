//
//  AppDelegate.h
//  Nooves
//
//  Created by Nikki Tran on 7/13/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *postsArray;

@end

