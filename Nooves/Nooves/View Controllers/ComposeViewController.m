//
//  ComposeViewController.m
//  Nooves
//
//  Created by Norette Ingabire on 7/16/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "Post.h"
#import "FirebasePost.h"

@interface ComposeViewController () <UIScrollViewDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *eventTitle;
@property (strong, nonatomic) UITextView *eventDescription;
@property (strong, nonatomic) NSArray *category;
@property (strong, nonatomic) UITextField *eventLocation;
// @property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSMutableArray *tempPostsArray;
// date
// category

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"New Event";
    
    self.category = @[@"Outdoors", @"Shopping", @"Partying", @"Eating", @"Arts", @"Sports", @"Networking", @"Fitness", @"Games", @"Concert", @"Cinema", @"Festival", @"Other"];
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    // instantiate and set properties for event title text field
    self.eventTitle = [[UITextField alloc] initWithFrame:CGRectMake(0, 0,
                                                                    1000, 150)];
    
    self.eventTitle.text = nil;
    self.eventTitle.placeholder = @"Event name";
    self.eventTitle.borderStyle = UITextBorderStyleRoundedRect;
    self.eventTitle.textColor = UIColor.grayColor;
    
    // instantiate and set properties for event location text field
    // need to connect actual locations from api
    self.eventLocation = [[UITextField alloc] initWithFrame:CGRectMake(0, 150, 1000, 150)];
    self.eventLocation.text = nil;
    self.eventLocation.placeholder = @"Add location";
    self.eventLocation.borderStyle = UITextBorderStyleRoundedRect;
    self.eventLocation.textColor = UIColor.grayColor;
    
    
    // instantiate and set properties for event description text view
    self.eventDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, 300, 100, 150)];
    self.eventDescription.delegate = self;
    self.eventDescription.text = @"Add a description";
    self.eventDescription.textColor = UIColor.grayColor;
    
    [self.view addSubview:self.eventTitle];
    [self.view addSubview:self.eventLocation];
    [self.view addSubview:self.eventDescription];

    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.backgroundColor = [UIColor brownColor];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    CGFloat descHeight = self.eventDescription.frame.origin.y + self.eventDescription.frame.size.height+1000.0;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, descHeight);
    
    // self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds, self.scrollView.bounds);
    CGRect contentRect = CGRectZero;
    
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.eventTitle];
    [self.scrollView addSubview:self.eventLocation];
    [self.scrollView addSubview:self.eventDescription];
    [self post];
    [self goBack];
}

- (void)pickerView:(UIPickerView *)thePickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
//    NSLog(@"Selected Color: %@. Index of selected color: %i",
//          [arrayColors objectAtIndex:row], row);
    
    //Now, if you want to navigate then;
    // Say, OtherViewController is the controller, where you want to navigate:
    //OtherViewController *objOtherViewController = [OtherViewController new];
    //[self.navigationController pushViewController:objOtherViewController animated:YES];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return 13;
}


- (void) textViewDidBeginEditing:(UITextView *)textView {
    if (textView.textColor == UIColor.grayColor) {
        textView.text = nil;
        textView.textColor = UIColor.blackColor;
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    if (textView.text == nil) {
        textView.text = @"Add description";
        textView.textColor = UIColor.grayColor;
    }
}

- (UIBarButtonItem *) post {
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] init];
    postButton.title = @"Share";
    postButton.target = self;
    postButton.action = @selector(didTapPost);
    self.navigationItem.rightBarButtonItem = postButton;
    return postButton;
}

- (UIBarButtonItem *) goBack {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(didTapBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
  return backButton;
}

- (void) didTapPost {
    // API call
    NSLog(@"User posted successfully");
}

- (void) didTapBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"User pressed to go back");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if(!self.isMoreDataLoading){
//        // Calculate the position of one screen length before the bottom of the results
//        int scrollViewContentHeight = self.tableView.contentSize.height;
//        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
//
//        // When the user has scrolled past the threshold, start requesting
//        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
//            self.isMoreDataLoading = true;
//
//            // ... Code to load more results ...
//            [self fetchPosts];
//            NSLog(@"More posts successfully fetched");
//        }
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
