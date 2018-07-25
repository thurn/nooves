//
//  TimelineViewController.h
//  Nooves
//
//  Created by Norette Ingabire on 7/17/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *tempPostsArray;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) NSArray *postsArray;
@property (strong, nonatomic) NSArray *filtedData;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *filteredData;

@end
