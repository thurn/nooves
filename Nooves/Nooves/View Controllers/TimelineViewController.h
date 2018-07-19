//
//  TimelineViewController.h
//  Nooves
//
//  Created by Norette Ingabire on 7/17/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *tempPostsArray;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *postsArray;
@end
