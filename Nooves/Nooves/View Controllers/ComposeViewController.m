#import "AppDelegate.h"
#import "CategoryPickerModalViewController.h"
#import "ComposeViewController.h"
#import "DatePickerModalViewController.h"
#import "LocationPickerModalViewController.h"
#import "PureLayout/PureLayout.h"
#import "TabBarController.h"
#import "TimelineViewController.h"

@interface ComposeViewController () <UITextViewDelegate, LocationPickerDelegate, CategoryPickerDelegate, DatePickerDelegate>

@property (nonatomic) UIPickerView *pickerView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"New Event";
    
    self.lat = [[NSNumber alloc] init];
    self.lng = [[NSNumber alloc] init];
    self.location = [[NSString alloc] init];
    
    // set up event title properties
    self.eventTitle = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 1000, 150)];
    self.eventTitle.text = nil;
    self.eventTitle.placeholder = @"Event name";
    self.eventTitle.borderStyle = UITextBorderStyleRoundedRect;
    self.eventTitle.textColor = UIColor.grayColor;
    
    // set location display label properties
    UILabel *locationLabel = [[UILabel alloc] init];
    NSString *locationColon = @"Location: ";
    locationLabel.frame = CGRectMake(10, 440, 100, 100);
    if(self.location) {
        locationLabel.text = [locationColon stringByAppendingString:self.location];
    } else {
        locationLabel.text = locationColon;
    }
    [locationLabel sizeToFit];
    
    // set activity display label properties
    UILabel *activityLabel = [[UILabel alloc] init];
    NSString *activityColon = @"Category: ";
    activityLabel.frame = CGRectMake(10, 420, 150, 150);
    NSString *activity = [Post activityTypeToString:self.activityType];
    activityLabel.text = [activityColon stringByAppendingString:activity];
    [activityLabel sizeToFit];

    // set date display label properties
    UILabel *dateLabel = [[UILabel alloc] init];
    NSString *dateColon = @"Date: ";
    dateLabel.frame = CGRectMake(10, 500, 100, 100);
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *dateDetails = [formatter stringFromDate:self.date];
    self.eventDescription.textColor = UIColor.grayColor;
    if(self.date) {
        dateLabel.text = [dateColon stringByAppendingString:dateDetails];
    } else {
        dateLabel.text = dateColon;
    }
    [dateLabel sizeToFit];
    [self.view addSubview:dateLabel];
    
    // set event description properties
    self.eventDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, 150, 1000, 150)];
    self.eventDescription.delegate = self;
    self.eventDescription.text = @"Add a description";
    self.eventDescription.textColor = UIColor.grayColor;
    
    CGRect contentRect = CGRectZero;

    for (UIView *view in self.view.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }

    // add components to view
    [self.view addSubview:self.eventTitle];
    [self.view addSubview:self.eventDescription];
    [self.view addSubview:activityLabel];
    [self.view addSubview:[self selectDate]];
    [self.view addSubview:dateLabel];
    [self.view addSubview:[self selectCategory]];
    [self.view addSubview:[self selectLocation]];
    [self.view addSubview:locationLabel];
    
    self.tabBarController.tabBar.hidden = YES;
    
    // add tab bar buttons to controller
    [self postButton];
    [self goBack];
    
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

// checks to see if user is editing event description and changes text color if true
- (void)textViewDidBeginEditing:(UITextView *)eventDescription {
    if (eventDescription.textColor == UIColor.grayColor) {
        eventDescription.text = nil;
        eventDescription.textColor = UIColor.blackColor;
    }
}

// if event description is nil continue setting text color to grey
- (void)textViewDidEndEditing:(UITextView *)eventDescription {
    if (eventDescription.text == nil) {
        eventDescription.text = @"Add description";
        eventDescription.textColor = UIColor.grayColor;
    }
}

// set up select date button properties
- (UIButton *)selectDate {
    UIButton *selectDate = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *calendarIcon = [UIImage imageNamed:@"calendar"];
    [selectDate setImage:calendarIcon forState:UIControlStateNormal];
    [selectDate addTarget:self action:@selector(didSelectDate) forControlEvents:UIControlEventTouchUpInside];
    selectDate.center = CGPointMake(0, 300);
    [selectDate sizeToFit];
    return selectDate;
}

// pass post data and jump to date picker view
- (void)didSelectDate {
    DatePickerModalViewController *datePicker = [DatePickerModalViewController new];
    datePicker.dateDelegate = self;
    UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:datePicker];
    [self presentViewController:navCont animated:YES completion:nil];
}

// set up select location properties
- (UIButton *)selectLocation {
    UIButton *selectLocation = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *locationIcon = [UIImage imageNamed:@"location-marker"];
    [selectLocation setImage:locationIcon forState:UIControlStateNormal];
    [selectLocation addTarget:self action:@selector(didSelectLocation) forControlEvents:UIControlEventTouchUpInside];
    selectLocation.center = CGPointMake(20, 300);
    [selectLocation sizeToFit];
    return selectLocation;
}

// pass post data and jump to location picker view
- (void)didSelectLocation {
    LocationPickerModalViewController *locationPicker = [LocationPickerModalViewController new];
    locationPicker.locationDelegate = self;
    UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:locationPicker];
    [self presentViewController:navCont animated:YES completion:nil];
}

// set up selection category button properties
- (UIButton *)selectCategory {
    UIButton *selectCategory = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *tagIcon = [UIImage imageNamed:@"tags"];
    [selectCategory setImage:tagIcon forState:UIControlStateNormal];
    [selectCategory addTarget:self action:@selector(didSelectCategory) forControlEvents:UIControlEventTouchUpInside];
    selectCategory.center = CGPointMake(50, 300);
    [selectCategory sizeToFit];
    return selectCategory;
}


// pass post data and jump to category picker view
- (void)didSelectCategory {
    CategoryPickerModalViewController *categoryPicker = [CategoryPickerModalViewController new];
    categoryPicker.categoryDelegate = self;
    UINavigationController *navCont = [[UINavigationController alloc] initWithRootViewController:categoryPicker];
    [self presentViewController:navCont animated:YES completion:nil];
}

// set up back button properties
- (UIBarButtonItem *)goBack {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(didTapBack)];
    self.navigationItem.leftBarButtonItem = backButton;

  return backButton;
}

// jump back to root view controller
- (void)didTapBack {
    TimelineViewController *timeline = [[TimelineViewController alloc] init];
    // timeline.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:timeline animated:YES];
    NSLog(@"User pressed to go back");
}

// set up post button properties
- (UIBarButtonItem *)postButton {
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(didTapPost)];
    self.navigationItem.rightBarButtonItem = postButton;
    return postButton;
}

// passes post data and adds to post array and jump back to timeline view
- (void)didTapPost {
    // post to timeline
    self.post = [[Post alloc] initPostWithDetails:self.date withTitle:self.eventTitle.text withDescription:self.eventDescription.text withType:self.activityType withLat:self.lat withLng:self.lng withID:nil];
    [Post postToFireBase:self.post];
    TimelineViewController *timeline = [[TimelineViewController alloc]init];
    [self.navigationController pushViewController:timeline animated:YES];
    NSLog(@"User posted successfully");
}

- (void)locationsPickerModalViewController:(LocationPickerModalViewController *)controller didPickLocationWithLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude location:(NSString *)location {
    
    self.location = location;
    self.lat = latitude;
    self.lng = longitude;

    [self.navigationController popToViewController:self animated:YES];
}

- (void)categoryPickerModalViewController:(CategoryPickerModalViewController *)controller didPickActivityType:(ActivityType *)activity {
    self.activityType = activity;
    
    [self.navigationController popToViewController:self animated:YES];
}

- (void)datePickerModalViewController:(DatePickerModalViewController *)dateController didPickDate:(NSDate *)date {
    self.date = date;
    [self.navigationController popToViewController:self animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
