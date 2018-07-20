//
//  DatePickerPopUpViewController.h
//  Nooves
//
//  Created by Nkenna Aniedobe on 7/19/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@interface DatePickerPopUpViewController : UIViewController
@property (strong, nonatomic) UIDatePicker *datepicker;
@property (strong, nonatomic) NSMutableArray *tempPostsArray;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) ActivityType *activityType;
@end
