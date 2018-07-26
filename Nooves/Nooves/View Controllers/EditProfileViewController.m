//
//  EditProfileViewController.m
//  Nooves
//
//  Created by Norette Ingabire on 7/25/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ProfileViewController.h"

@interface EditProfileViewController () <UITextViewDelegate>

@property(strong, nonatomic) UIImageView *profilePic;
@property(strong, nonatomic) UITextField *userName;
@property(strong, nonatomic) UITextView *bioInfo;
@property(strong, nonatomic) UIBarButtonItem *saveProfile;

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureView];
    if (!self.usersArray) {
        self.usersArray = [[NSMutableArray alloc]init];
    }
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Edit Profile";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureView {
    
    //set up the profile pic field
    self.profilePic = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 100, 100)];
    [self.profilePic setImage:[UIImage imageNamed:@"profile-blank"]];
    [self.profilePic sizeToFit];
    
    // set up the name field
    self.userName = [[UITextField alloc]initWithFrame:CGRectMake(10, 150, 100, 100)];
    self.userName.placeholder = @"Enter full name";
    [self.userName sizeToFit];
    self.userName.textColor = [UIColor grayColor];
    
    // set up the bio field
    self.bioInfo = [[UITextView alloc]initWithFrame:CGRectMake(10, 230, 500, 100)];
    self.bioInfo.delegate = self;
    self.bioInfo.text = @"Enter bio here";
    self.bioInfo.textColor = [UIColor grayColor];
    
    // set up the save profile button
    self.saveProfile = [[UIBarButtonItem alloc]init];
    self.saveProfile.title = @"Done";
    self.navigationItem.rightBarButtonItem = self.saveProfile;
    
    self.saveProfile.target = self;
    self.saveProfile.action = @selector(didTapSaveProfile);
    
    // add all the subviews to the view
    [self.view addSubview:self.profilePic];
    [self.view addSubview:self.userName];
    [self.view addSubview:self.bioInfo];
}

// change the text color if the user is editing their bio
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView.textColor == UIColor.grayColor) {
        textView.text = nil;
        textView.textColor = UIColor.blackColor;
    }
}

// change the color back to gray if the user is done editing
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text == nil) {
        textView.text = @"Enter bio here";
        textView.textColor = UIColor.grayColor;
    }
}

- (void)didTapSaveProfile {
    
    // save all the info to the profile page
    self.user = [[User alloc]initProfileWithInfo:self.userName.text withBio:self.bioInfo.text];
    [self.delegate didUpdateProfile:self.user];
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"calling didUpdateProfile");
}


@end
