//
//  CategoryPickerPopUpViewController.h
//  Nooves
//
//  Created by Nikki Tran on 7/19/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "FirebasePost.h"

@interface CategoryPickerPopUpViewController : UIViewController
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSMutableArray *categoriesArray;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UILabel *categoryLabel;
@property (strong, nonatomic) NSMutableArray *tempPostsArray;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;
@end
