//
//  LocationPickerPopUpViewController.h
//  Nooves
//
//  Created by Nikki Tran on 7/23/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mapkit/Mapkit.h>
#import <CoreLocation/CoreLocation.h>
#import "Post.h"

@interface LocationPickerPopUpViewController : UIViewController

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *tempPostsArray;
@property (strong, nonatomic) NSDate *date;
@property (nonatomic) ActivityType activityType;

@end
