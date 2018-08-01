//
//  PostDetailsViewController.m
//  Nooves
//
//  Created by Nkenna Aniedobe on 7/31/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "AppDelegate.h"
#import <FIRDatabase.h>
#import "ProfileViewController.h"
#import "PureLayout/PureLayout.h"
#import "TimelineViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface PostDetailsViewController ()
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UILabel *phoneNumberLabel;
@property (strong, nonatomic) UIImageView *profilePicImage;
@property (strong, nonatomic) UILabel *activityTitleLabel;
@property (strong, nonatomic) UILabel *activityDescriptionLabel;
@property (strong, nonatomic) UILabel *activityDateAndTimeLabel;
@property (strong, nonatomic) UILabel *activityTypeLabel;
@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    FIRDatabaseReference *reference = [[FIRDatabase database]reference];
    /*FIRDatabaseHandle *databaseHandle = [[[reference child:@"Users"]child:self.post.userID]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *usersDictionary = snapshot.value;
        if (![snapshot.value isEqual:[NSNull null]]) {
            self.user = [[User alloc] initFromDatabase:usersDictionary];
            if (![self.user.profilePicURL isEqualToString:@"nil"]){
                NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:self.user.profilePicURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if(error){
                        NSLog(@"%@", error);
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.profilePicImage.image = [UIImage imageWithData:data];
                    });
                }];
                [task resume];
            }
        }
        else {
            FIRDatabaseReference *userRef = [[reference child:@"Users"]child:[FIRAuth auth].currentUser.uid];
            [userRef setValue:@{@"Age":@(0), @"Bio":@"nil", @"Name":[FIRAuth auth].currentUser.displayName,@"PhoneNumber":@(0), @"ProfilePicURL":@"nil"}];
        }
    }];*/
    self.profilePicImage = [[UIImageView alloc] init];
    self.profilePicImage.frame = CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height*9/20));
    [self.view addSubview:self.profilePicImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initting

- (instancetype)initFromTimeline:(Post *)post {
    self = [super init];
    self.post = post;
    return self;
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
