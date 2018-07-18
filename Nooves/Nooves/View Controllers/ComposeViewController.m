//
//  ComposeViewController.m
//  Nooves
//
//  Created by Norette Ingabire on 7/16/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "ActivityType.h"

@interface ComposeViewController ()

@property (strong, nonatomic) UITextField *eventTitle;
@property (strong, nonatomic) UITextView *eventDescription;
// date
// category

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"New Event";

    //UIView *buttonView = [[UIView alloc] init];
    //[self.view addSubview: buttonView];
    [self post];
    [self goBack];
}

- (UITextView *) event {
    UITextView *eventTitle = [[UITextView alloc] init];
    eventTitle.text = @"Add title here";
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

    UIView *view = [[UIView alloc] init];

   // [self.view addSubview: postButton];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
