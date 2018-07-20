//
//  CategoryPickerPopUpViewController.h
//  Nooves
//
//  Created by Nikki Tran on 7/19/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface CategoryPickerPopUpViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) UIPickerView *pickerView;
@end
