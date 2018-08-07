//
//  UserViewController.m
//  Nooves
//
//  Created by Nkenna Aniedobe on 8/6/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "UserViewController.h"
#import "User.h"
#import <FIRAuth.h>
#import <FIRDatabase.h>

@interface UserViewController ()

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UIImageView *profilePicture;
@property (strong, nonatomic) UILabel *nameAndAgeLabel;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    while (!self.user) {
    }
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithUserID:(NSString *)userID {
    self = [super init];
    FIRDatabaseReference *reference = [[FIRDatabase database]reference];
    FIRDatabaseHandle *databaseHandle = [[[reference child:@"Users"]child:userID]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
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
                        self.user.profilePic = [UIImage imageWithData:data];
                    });
                }];
                [task resume];
            }
            else {
                self.profilePicture.image = [UIImage imageNamed:@"profile-blank"];
            }
        }
        else {
            FIRDatabaseReference *userRef = [[reference child:@"Users"]child:[FIRAuth auth].currentUser.uid];
            [userRef setValue:@{@"Age":@(0), @"Bio":@"nil", @"Name":[FIRAuth auth].currentUser.displayName,@"PhoneNumber":@(0), @"ProfilePicURL":@"nil",@"EventsGoing":@[@"a"]}];
        }
    }];
    [self.navigationItem setTitle:self.user.name];
    return self;
}
- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.profilePicture.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*9/20);
    [self.view addSubview:self.profilePicture];
    self.nameAndAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height*11/20, 10, 10)];
    NSString *nameAndAge = [[self.user.name stringByAppendingString:@", "] stringByAppendingString:[self.user.age stringValue]];
    self.nameAndAgeLabel.text = nameAndAge;
    [self.nameAndAgeLabel sizeToFit];
    [self.nameAndAgeLabel setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height/2)];
    [self.view addSubview:self.nameAndAgeLabel];
    while (!self.user.profilePic) {
    }
    self.profilePicture.image = self.user.profilePic;
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
