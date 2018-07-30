#import "EditProfileViewController.h"
#import "ProfileViewController.h"
#import "PureLayout/PureLayout.h"
#import "User.h"

@interface ProfileViewController () <editProfileDelegate>

@property(strong, nonatomic) UIImageView *profilePicture;
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *bioLabel;
@property(strong, nonatomic) UILabel *ageLabel;
@property(strong, nonatomic) UILabel *contactNumberLabel;
@property(strong, nonatomic) UIButton *editProfile;
@property(strong, nonatomic) NSDictionary *usersDictionary;
@property(nonatomic) NSArray *usersArray;
@property(strong, nonatomic) User *user;

@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set the database reference
    FIRDatabaseReference *reference = [[FIRDatabase database]reference];
    FIRDatabaseHandle *databaseHandle = [[reference child:@"Users"]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.usersDictionary = snapshot.value;
        self.usersArray = [User readUsersFromDatabase:self.usersDictionary];
    }];
    
    [self configureProfile];

    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Profile";
    
    if (!self.usersArray) {
        self.usersArray = [[NSMutableArray alloc]init];
    }
    
    if (self.user) {
        [self didUpdateProfile:self.user];
    }
    
    if (!self.user) {
        NSLog(@"self.user does not exist");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureProfile {
    
    // set the background color
    self.view.backgroundColor = [UIColor whiteColor];
    
    // set up the profile picture field
    self.profilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 100, 100)];
    [self.profilePicture setImage:[UIImage imageNamed:@"profile-blank"]];
    [self.profilePicture sizeToFit];
    
    //set up the name label field
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 80, 30, 30)];
    self.nameLabel.text = @"Name";
    [self.nameLabel sizeToFit];
    
    //set up the age field
    self.ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 130, 30, 30)];
    self.ageLabel.text = @"Age";
    [self.ageLabel sizeToFit];
    
    // set up the phone number field
    self.contactNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 170, 30, 30)];
    self.contactNumberLabel.text = @"Phone number";
    [self.contactNumberLabel sizeToFit];
    
    // set up the bio field
    self.bioLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, 200, 50)];
    self.bioLabel.text = @"Bio";
    [self.bioLabel sizeToFit];
    
    // set up the edit profile button
    self.editProfile = [[UIButton alloc]initWithFrame:CGRectMake(150, 350, 30, 30)];
    [self.editProfile setTitle:@"Edit Profile" forState:UIControlStateNormal];
    [self.editProfile setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.editProfile sizeToFit];
    [self.editProfile addTarget:self action:@selector(didTapEditProfile) forControlEvents:UIControlEventTouchUpInside];
    
    // add all subviews to the view
    [self.view addSubview:self.profilePicture];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.ageLabel];
    [self.view addSubview:self.contactNumberLabel];
    [self.view addSubview:self.bioLabel];
    [self.view addSubview:self.editProfile];
}

- (void)didTapEditProfile {
    EditProfileViewController *newProfile = [[EditProfileViewController alloc]init];
    [self.navigationController pushViewController:newProfile animated:YES];
}

- (void)didUpdateProfile:(User *)user {
     self.user = user;
    
    //convert age to a string
    NSNumber *userAge = user.age;
    NSString *ageInString = [userAge stringValue];
    
    //convert phone number to string
    NSNumber *userNumber = user.phoneNumber ;
    NSString *phoneNumberInString = [userNumber stringValue];
    
    self.nameLabel.text = user.name;
    self.bioLabel.text = user.biography;
    self.contactNumberLabel.text = phoneNumberInString;
    self.ageLabel.text = ageInString;
    NSLog(@"profile page name: %@", self.nameLabel.text);
    NSLog(@"profile page bio: %@", self.bioLabel.text);
    NSLog(@"didupdateProfile was called");
}

@end
