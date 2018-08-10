//
//  UserViewController.m
//  Nooves
//
//  Created by Nkenna Aniedobe on 8/6/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "UserViewController.h"
#import <FIRAuth.h>
#import <FIRDatabase.h>
#import "UIImageView+Cache.h"
#import "PostCell.h"
#import "User.h"
#import "PostDetailsViewController.h"
@interface UserViewController () <UITableViewDelegate, UITableViewDataSource, PostCellDelegate>

@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UIImageView *profilePicture;
@property (strong, nonatomic) UILabel *nameAndAgeLabel;
@property (strong, nonatomic) UITableView *tableview;
@property (strong, nonatomic) UILabel *bioLabel;
@property (strong, nonatomic) NSArray *eventsGoing;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sleep(1);
    self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*.6, self.view.frame.size.width, self.view.frame.size.height*.4-[UITabBar new].frame.size.height-65)];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    self.tableview.backgroundColor = [UIColor whiteColor];
    [self.tableview registerClass:[PostCell class] forCellReuseIdentifier:@"postCellIdentifier"];
    [self.view addSubview:self.tableview];
    [self fetchGoing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)didTapProfilePic:(NSString *)userID{
    UserViewController *newUser = [[UserViewController alloc] initWithUserID:userID];
    [self.navigationController pushViewController:newUser animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *pickedPost = self.eventsGoing[indexPath.row];
    PostDetailsViewController *postDetail = [[PostDetailsViewController alloc] initFromTimeline:pickedPost];
    [self.navigationController pushViewController:postDetail animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.eventsGoing.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostCell *cell =[tableView dequeueReusableCellWithIdentifier:@"postCellIdentifier" forIndexPath:indexPath];
    cell.postDelegate = self;
    Post *newPost = self.eventsGoing[indexPath.row];
    [cell configurePost:newPost];
    return cell;
}

- (instancetype)initWithUserID:(NSString *)userID {
    self = [super init];
    FIRDatabaseReference *reference = [[FIRDatabase database]reference];
    FIRDatabaseHandle *databaseHandle = [[[reference child:@"Users"]child:userID]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *usersDictionary = snapshot.value;
        if (![snapshot.value isEqual:[NSNull null]]) {
            self.user = [[User alloc] initFromDatabase:usersDictionary];
            if (![self.user.profilePicURL isEqualToString:@"nil"]){
                self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*9/20)];
                [self.view addSubview:self.profilePicture];
                [self.profilePicture loadURLandCache:self.user.profilePicURL];
                [self setUI];
                NSLog(@"UI SEet");
            }
            else {
                self.profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*9/20)];
                self.profilePicture.image = [UIImage imageNamed:@"profile-blank"];
                [self.view addSubview:self.profilePicture];
                [self setUI];
                NSLog(@"UI Set");
            }
        }
        else {
            FIRDatabaseReference *userRef = [[reference child:@"Users"]child:[FIRAuth auth].currentUser.uid];
            [userRef setValue:@{@"Age":@(0), @"Bio":@"nil", @"Name":[FIRAuth auth].currentUser.displayName,@"PhoneNumber":@(0), @"ProfilePicURL":@"nil",@"EventsGoing":@[@"a"]}];
        }
    }];
    [self.navigationItem setTitle:self.user.name];
    NSLog(@"Image set");
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
    self.bioLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height*.6, 10, 10)];
    self.bioLabel.text = self.user.biography;
    [self.bioLabel sizeToFit];
    [self.bioLabel setCenter:CGPointMake(self.view.center.x, self.view.frame.size.height*.57)];
    [self.view addSubview:self.bioLabel];
}

- (void)fetchGoing {
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    [[ref child:@"Posts"] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *postsDict = snapshot.value;
        if (![snapshot.value isEqual:[NSNull null]]){
            for (NSString* userKey in postsDict) {
                for (NSString *IDKey in postsDict[userKey]) {
                    if ([self.user.eventsGoing containsObject:IDKey]) {
                        Post *posty = [[Post alloc] init];
                        posty.userID = userKey;
                        posty.activityTitle = postsDict[userKey][IDKey][@"Title"];
                        posty.activityDescription = postsDict[userKey][IDKey][@"Description"];
                        posty.userID = userKey;
                        posty.activityLat = postsDict[userKey][IDKey][@"Latitude"];
                        posty.activityLng = postsDict[userKey][IDKey][@"Longitude"];
                        posty.activityLocation = postsDict[userKey][IDKey][@"Location"];
                        ActivityType type = [postsDict[userKey][IDKey][@"Activity Type"] integerValue];
                        posty.activityType = type;
                        posty.usersGoing = [postsDict[userKey][IDKey][@"UsersGoing"] copy];
                        NSInteger date = [postsDict[userKey][IDKey][@"Date"] integerValue];
                        NSDate *daty = [NSDate dateWithTimeIntervalSince1970:date];
                         posty.timestamp = [postsDict[userKey][IDKey][@"TimeStamp"] integerValue];
                        posty.activityDateAndTime = daty;
                        [myArray addObject:posty];
                    }
                }
            }
            self.eventsGoing = myArray;
            [self.tableview reloadData];
        }
    }];
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


