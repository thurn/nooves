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

@interface ComposeViewController () <UIScrollViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) UITextField *eventTitle;
@property (strong, nonatomic) UITextView *eventDescription;
// date
// location
// category

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"New Event";
    
    // instantiate and set properties for event title text field
    self.eventTitle = [[UITextField alloc] initWithFrame:CGRectMake(0, 0,
                                                                    1000, 150)];
    self.eventTitle.text = nil;
    self.eventTitle.placeholder = @"Event name";
    self.eventTitle.borderStyle = UITextBorderStyleRoundedRect;
    self.eventTitle.textColor = UIColor.grayColor;
    
    // instantiate and set properties for event description text view
    self.eventDescription = [[UITextView alloc] initWithFrame:CGRectMake(0, 200, 100, 150)];
    self.eventDescription.delegate = self;
    self.eventDescription.text = @"Add description";
    self.eventDescription.textColor = UIColor.grayColor;
    
    [self.view addSubview:self.eventTitle];
    [self.view addSubview:self.eventDescription];
    
    //     UIScrollView *scrollView = [[UIScrollView alloc] init];
    //
    //     self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    //     self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.width, 40);

    [self post];
    [self goBack];
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
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon.png"]
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
