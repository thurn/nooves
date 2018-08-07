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
#import "UIImageView+Cache.h"
@interface UserViewController ()

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UIImageView *profilePicture;
@property (strong, nonatomic) UILabel *nameAndAgeLabel;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
            if (![self.user.profilePicURL isEqualToString:@"ni CGl"]){
                self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*9/20)];
                [self.view addSubview:self.profilePicture];
                [self.profilePicture loadURLandCache:self.user.profilePicURL];
                [self setUI];
            }
            else {
                self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*9/20)];
                self.profilePicture.image = [UIImage imageNamed:@"profile-blank"];
                [self.view addSubview:self.profilePicture];
                [self setUI];
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
    self.nameAndAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height*11/20, 10, 10)];
    NSString *nameAndAge = [[self.user.name stringByAppendingString:@", "] stringByAppendingString:[self.user.age stringValue]];
    self.nameAndAgeLabel.text = nameAndAge;
    [self.nameAndAgeLabel sizeToFit];
    [self.nameAndAgeLabel setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height/2)];
    [self.view addSubview:self.nameAndAgeLabel];
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
