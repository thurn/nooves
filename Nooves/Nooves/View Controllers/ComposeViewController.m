//
//  ComposeViewController.m
//  Nooves
//
//  Created by Norette Ingabire on 7/16/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "ComposeViewController.h"
#import "AppDelegate.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Compose";
    
    // right navigation bar button
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post"
        style:UIBarButtonItemStylePlain
        target:self
        action:@selector(didTapPost:)];
    self.navigationItem.rightBarButtonItem = postButton;
    // [postButton release];
    
    // left navigation bar button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon.png"]
        style:UIBarButtonItemStylePlain
        target:self
        action:@selector(didTapBack:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    
   // [self.view addSubview: postButton];
}

- (void) didTapPost {
    
}

- (void) didTapBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
