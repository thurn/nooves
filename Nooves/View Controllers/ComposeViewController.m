#import "AppDelegate.h"
#import "ComposeViewController.h"
#import "EventsViewController.h"
#import "PureLayout/PureLayout.h"
#import "TabBarController.h"
#import "TimelineViewController.h"
#import <FirebaseAuth.h>
#import "CategoryPickerModalViewController.h"
#import "DatePickerModalViewController.h"
#import "LocationPickerModalViewController.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface ComposeViewController () <UITextViewDelegate, LocationPickerDelegate,
CategoryPickerDelegate, DatePickerDelegate, EventsSearchDelegate>

@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic) UILabel *locationLabel;
@property (nonatomic) UILabel *activityLabel;
@property (nonatomic) UILabel *dateLabel;
@property (nonatomic) BOOL uploading;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    hud.mode = MBProgressHUDModeAnnularDeterminate;
//    [self.view addSubview:hud];

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"New Event";
    self.uploading = NO;

    CGRect contentRect = CGRectZero;
    for (UIView *view in self.view.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    
    self.locationLabel = [[UILabel alloc] init];
    self.activityLabel = [[UILabel alloc] init];
    self.dateLabel = [[UILabel alloc] init];
    self.lat = [[NSNumber alloc] init];
    self.lng = [[NSNumber alloc] init];
    self.location = [[NSString alloc] init];
    
    self.eventTitle = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 1000, 150)];
    self.eventTitle.text = nil;
    self.eventTitle.placeholder = @"Event name";
    self.eventTitle.borderStyle = UITextBorderStyleRoundedRect;
    self.eventTitle.textColor = UIColor.grayColor;
    
    self.eventDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, 150, 1000, 150)];
    self.eventDescription.delegate = self;
    self.eventDescription.text = @"Add a description";
    self.eventDescription.textColor = UIColor.grayColor;

    [self.view addSubview:self.eventTitle];
    [self.view addSubview:self.eventDescription];
    [self.view addSubview:[self selectDate]];
    [self.view addSubview:[self selectCategory]];
    [self.view addSubview:[self selectLocation]];
    
    [self postButton];
    [self createBackButton];
    [self searchEventsButton];
    [self enterLocationField];
    
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    // sets location display properties
    NSString *locationColon = @"Location: ";
    self.locationLabel.frame = CGRectMake(10, 440, 100, 100);
    if(self.location) {
        self.locationLabel.text = [locationColon stringByAppendingString:self.location];
    } else {
        self.locationLabel.text = locationColon;
    }
    [self.locationLabel sizeToFit];
    
    // sets activity display label properties
    NSString *activityColon = @"Category: ";
    self.activityLabel.frame = CGRectMake(10, 420, 150, 150);
    NSString *activity = [Post activityTypeToString:self.activityType];
    self.activityLabel.text = [activityColon stringByAppendingString:activity];
    [self.activityLabel sizeToFit];
    
    // sets date display label properties
    NSString *dateColon = @"Date: ";
    self.dateLabel.frame = CGRectMake(10, 500, 100, 100);
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"MM-dd HH:mm";
    NSString *dateDetails = [formatter stringFromDate:self.date];
    self.eventDescription.textColor = UIColor.grayColor;
    if(self.date) {
        self.dateLabel.text = [dateColon stringByAppendingString:dateDetails];
    } else {
        self.dateLabel.text = dateColon;
    }
    [self.dateLabel sizeToFit];
    
    // adds labels to view
    [self.view addSubview:self.dateLabel];
    [self.view addSubview:self.locationLabel];
    [self.view addSubview:self.activityLabel];
}

// changes text color when user edits text view
- (void)textViewDidBeginEditing:(UITextView *)eventDescription {
    if (eventDescription.textColor == UIColor.grayColor) {
        eventDescription.text = nil;
        eventDescription.textColor = UIColor.blackColor;
    }
}

// changes text color when user stops editing text view
- (void)textViewDidEndEditing:(UITextView *)eventDescription {
    if (eventDescription.text == nil) {
        eventDescription.text = @"Add description";
        eventDescription.textColor = UIColor.grayColor;
    }
}

// sets up select date button properties
- (UIButton *)selectDate {
    UIButton *selectDate = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *calendarIcon = [UIImage imageNamed:@"calendar"];
    [selectDate setImage:calendarIcon forState:UIControlStateNormal];
    [selectDate addTarget:self
                   action:@selector(didSelectDate)
         forControlEvents:UIControlEventTouchUpInside];
    selectDate.center = CGPointMake(0, 300);
    [selectDate sizeToFit];
    return selectDate;
}

// conforms to date picker delegate and jumps to date picker view
- (void)didSelectDate {
    DatePickerModalViewController *datePicker = [DatePickerModalViewController new];
    datePicker.dateDelegate = self;
    UINavigationController *navCont = [[UINavigationController alloc]
                                       initWithRootViewController:datePicker];
    [self presentViewController:navCont animated:YES completion:nil];
}

// sets up select location properties
- (UIButton *)selectLocation {
    UIButton *selectLocation = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *locationIcon = [UIImage imageNamed:@"location-marker"];
    [selectLocation setImage:locationIcon forState:UIControlStateNormal];
    [selectLocation addTarget:self
                       action:@selector(didSelectLocation)
             forControlEvents:UIControlEventTouchUpInside];
    selectLocation.center = CGPointMake(20, 300);
    [selectLocation sizeToFit];
    return selectLocation;
}

// conforms to location picker delegate and jumps to location picker view
- (void)didSelectLocation {
    LocationPickerModalViewController *locationPicker = [LocationPickerModalViewController new];
    locationPicker.locationDelegate = self;
    UINavigationController *navCont = [[UINavigationController alloc]
                                       initWithRootViewController:locationPicker];
    [self presentViewController:navCont animated:YES completion:nil];
}

// sets up selection category button properties
- (UIButton *)selectCategory {
    UIButton *selectCategory = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *tagIcon = [UIImage imageNamed:@"tags"];
    [selectCategory setImage:tagIcon forState:UIControlStateNormal];
    [selectCategory addTarget:self
                       action:@selector(didSelectCategory)
             forControlEvents:UIControlEventTouchUpInside];
    selectCategory.center = CGPointMake(50, 300);
    [selectCategory sizeToFit];
    return selectCategory;
}

// conforms to category picker delegate and jumps to category picker view
- (void)didSelectCategory {
    CategoryPickerModalViewController *categoryPicker = [CategoryPickerModalViewController new];
    categoryPicker.categoryDelegate = self;
    UINavigationController *navCont = [[UINavigationController alloc]
                                       initWithRootViewController:categoryPicker];
    [self presentViewController:navCont animated:YES completion:nil];
}

// sets up back button properties
- (UIBarButtonItem *)createBackButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back-icon"]
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                          action:@selector(didTapBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;

  return backButton;
}

// jumps back to root view controller
- (void)didTapBackButton {
    [self dismissViewControllerAnimated:true completion:nil];
}

// sets up post button properties
- (UIBarButtonItem *)postButton {
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Share"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(didTapPost)];
    self.navigationItem.rightBarButtonItem = postButton;
    return postButton;
}

// passes post data to post array and jumps back to timeline view
// TODO(Nikki): add progress HUD when user posts
- (void)didTapPost {
    // post to timeline
    if (self.post == nil && !self.uploading) {
        self.post = [[Post alloc] initPostWithDetails:self.date
                                            withTitle:self.eventTitle.text
                                      withDescription:self.eventDescription.text
                                             withType:self.activityType
                                              withLat:self.lat
                                              withLng:self.lng
                                               withID:nil
                                         withLocation:self.location];
        self.uploading = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Post postToFireBase:self.post];
        FIRDatabaseReference *reference = [[FIRDatabase database] reference];
        FIRDatabaseHandle *databaseHandle = [[[reference child:@"Users"]child:self.post.userID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            if (![snapshot.value isEqual:[NSNull null]]) {
            }
            else {
                FIRDatabaseReference *userRef = [[reference child:@"Users"]child:self.post.userID];
                [userRef setValue:@{@"Age":@(0), @"Bio":@"nil", @"Name":[FIRAuth auth].currentUser.displayName,@"PhoneNumber":@(0), @"ProfilePicURL":@"nil",@"EventsGoing":@[@"a"]}];
            }
        }];
        self.uploading = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        TimelineViewController *timeline = [[TimelineViewController alloc] init];
        [self.navigationController pushViewController:timeline animated:YES];
        NSLog(@"User posted successfully");
    } else {
        NSLog(@"Nothing to post");
    }
}

// stores data from location picker
- (void)locationsPickerModalViewController:(LocationPickerModalViewController *)controller
               didPickLocationWithLatitude:(NSNumber *)latitude
                                 longitude:(NSNumber *)longitude
                                  location:(NSString *)location {
    self.location = location;
    self.lat = latitude;
    self.lng = longitude;
    [self.navigationController popToViewController:self animated:YES];
}

// stores data from category picker
- (void)categoryPickerModalViewController:(CategoryPickerModalViewController *)controller
                      didPickActivityType:(ActivityType *)activity {
    self.activityType = activity;
    [self.navigationController popToViewController:self animated:YES];
}

// stores data from date picker
- (void)datePickerModalViewController:(DatePickerModalViewController *)dateController
                          didPickDate:(NSDate *)date {
    self.date = date;
    [self.navigationController popToViewController:self animated:YES];
}

- (UITextField *)enterLocationField {
    UITextField *eventLocation = [[UITextField alloc]initWithFrame:CGRectMake(50, 570, 150, 20)];
    eventLocation.placeholder = @"Enter location to search for local events...";
    [eventLocation sizeToFit];
    eventLocation.textColor = [UIColor grayColor];
  //  [self.view addSubview:eventLocation];
    return eventLocation;
}

// set up button to select local events
-(UIButton *)searchEventsButton {
    UIButton *eventsButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 600, 100, 100)];
    [eventsButton setTitle:@"Search for local events" forState:UIControlStateNormal];
    [eventsButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [eventsButton sizeToFit];
    [self.view addSubview:eventsButton];
    [eventsButton addTarget:self action:@selector(didTapEvents) forControlEvents:UIControlEventTouchUpInside];
    return eventsButton;
}

- (void)didTapEvents {
    EventsViewController *chooseEvent = [[EventsViewController alloc]init];
    chooseEvent.eventsDelegate = self;
    UINavigationController *navCont = [[UINavigationController alloc]
                                       initWithRootViewController:chooseEvent];
    //[self.navigationController presentViewController:navCont animated:YES];
    [self.navigationController presentViewController:navCont animated:YES completion:nil];
}

- (void)eventsViewController:(EventsViewController *)controller didSelectEventWithTitle:(NSString *)title
             withDescription:(NSString *)description
                   withVenue:(NSString *)venue {
    self.eventTitle.text = title;
    self.eventDescription.text = description;
    self.location = venue;
    [self.navigationController popToViewController:self animated:YES];
}

@end
