#import "AppDelegate.h"
#import "CategoryPickerPopUpViewController.h"
#import "ComposeViewController.h"
#import "DatePickerPopUpViewController.h"
#import "FirebasePost.h"
#import "LocationPickerPopUpViewController.h"
#import "PureLayout/PureLayout.h"
#import "TimelineViewController.h"

@interface ComposeViewController () <UITextViewDelegate>

// @property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UILabel *eventNameLabel;
@property (nonatomic) UITextField *eventTitle;
@property (nonatomic) UITextView *eventDescription;
@property (nonatomic) UIPickerView *pickerView;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if(!self.tempPostsArray) {
        self.tempPostsArray = [[NSMutableArray alloc] init];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"New Event";
    
    //set up event name label
    self.eventNameLabel = [[UILabel alloc]init];
    self.eventNameLabel.frame = CGRectMake(0, 0, 100, 100);
    self.eventNameLabel.hidden = NO;
    self.eventNameLabel.text = @"Event Name";
    [self.eventNameLabel sizeToFit];
    
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
    locationLabel.text = [locationColon stringByAppendingString:@"test"];
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

    // set scroll view properties
    //self.view.translatesAutoresizingMaskIntoConstraints = NO;
    //self.view.backgroundColor = [UIColor brownColor];
    //self.view = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    // CGFloat descHeight = self.eventDescription.frame.origin.y + self.eventDescription.frame.size.height+1000.0;
    // self.view.contentSize = CGSizeMake(self.view.frame.size.width, descHeight);
    
    CGRect contentRect = CGRectZero;

    for (UIView *view in self.view.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    
    //self.view.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    // add scroll view to subview
    //[self.view addSubview:self.scrollView];
    
    // add components to scroll view
    [self.view addSubview:self.eventNameLabel];
    [self.view addSubview:self.eventTitle];
    [self.view addSubview:self.eventDescription];
    [self.view addSubview:activityLabel];
    [self.view addSubview:[self selectDate]];
    [self.view addSubview:dateLabel];
    [self.view addSubview:[self selectCategory]];
    [self.view addSubview:[self selectLocation]];
    [self.view addSubview:locationLabel];
    
    // add tab bar buttons to controller
    [self postButton];
    [self goBack];
}

// checks to see if user is editing event description and changes text color if true
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.textColor == UIColor.grayColor) {
        textView.text = nil;
        textView.textColor = UIColor.blackColor;
    }
}

// if event description is nil continue setting text color to grey
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text == nil) {
        textView.text = @"Add description";
        textView.textColor = UIColor.grayColor;
    }
}

// set up select date button properties
-(UIButton *)selectDate {
    UIButton *selectDate = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *calendarIcon = [UIImage imageNamed:@"calendar"];
    [selectDate setImage:calendarIcon forState:UIControlStateNormal];
    [selectDate addTarget:self action:@selector(didSelectDate) forControlEvents:UIControlEventTouchUpInside];
    selectDate.center = CGPointMake(0, 300);
    [selectDate sizeToFit];
    return selectDate;
}

// pass post data and jump to date picker view
-(void)didSelectDate {
    DatePickerPopUpViewController *datePicker = [DatePickerPopUpViewController new];
    datePicker.tempPostsArray = self.tempPostsArray;
    datePicker.date = self.date;
    datePicker.activityType = self.activityType;
    [self.navigationController pushViewController:datePicker animated:YES];
}

// set up select location properties
-(UIButton *)selectLocation {
    UIButton *selectLocation = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *locationIcon = [UIImage imageNamed:@"location-marker"];
    [selectLocation setImage:locationIcon forState:UIControlStateNormal];
    [selectLocation addTarget:self action:@selector(didSelectLocation) forControlEvents:UIControlEventTouchUpInside];
    selectLocation.center = CGPointMake(20, 300);
    [selectLocation sizeToFit];
    return selectLocation;
}

// pass post data and jump to location picker view
-(void)didSelectLocation {
    LocationPickerPopUpViewController *locationPicker = [LocationPickerPopUpViewController new];
    locationPicker.tempPostsArray = self.tempPostsArray;
    locationPicker.date = self.date;
    locationPicker.activityType = self.activityType;
    [self.navigationController pushViewController:locationPicker animated:YES];
}

// set up selection category button properties
-(UIButton *)selectCategory {
    UIButton *selectCategory = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *tagIcon = [UIImage imageNamed:@"tags"];
    [selectCategory setImage:tagIcon forState:UIControlStateNormal];
    [selectCategory addTarget:self action:@selector(didSelectCategory) forControlEvents:UIControlEventTouchUpInside];
    selectCategory.center = CGPointMake(50, 300);
    [selectCategory sizeToFit];
    return selectCategory;
}


// pass post data and jump to category picker view
-(void)didSelectCategory {
    CategoryPickerPopUpViewController *categoryPicker = [CategoryPickerPopUpViewController new];
    categoryPicker.tempPostsArray = self.tempPostsArray;
    categoryPicker.date = self.date;
    categoryPicker.activityType = self.activityType;
    [self.navigationController pushViewController:categoryPicker animated:YES];
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
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"User pressed to go back");
}

// set up post button properties
- (UIBarButtonItem *)postButton {
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Share"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(didTapPost)];
    self.navigationItem.rightBarButtonItem = postButton;
    return postButton;
}

// passes post data and adds to post array and jump back to timeline view
- (void)didTapPost {
    // API call
    self.post = [[Post alloc] MakePost:self.date withTitle:self.eventTitle.text withDescription:self.eventDescription.text withType:self.activityType];
    [self.tempPostsArray addObject:self.post];
    TimelineViewController *timeline = [[TimelineViewController alloc]init];
    timeline.tempPostsArray = self.tempPostsArray;
    [self.navigationController pushViewController:timeline animated:YES];
    NSLog(@"User posted successfully");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
