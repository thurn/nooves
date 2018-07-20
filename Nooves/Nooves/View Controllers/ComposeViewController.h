//
//  ComposeViewController.h
//  Nooves
//
//  Created by Norette Ingabire on 7/16/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
@interface ComposeViewController : UIViewController
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *eventTitle;
@property (strong, nonatomic) UITextView *eventDescription;
@property (strong, nonatomic) NSArray *category;
@property (strong, nonatomic) UITextField *eventLocation;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *tempPostsArray;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) NSDate *date;
@end
