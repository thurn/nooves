#import <ChameleonFramework/Chameleon.h>
#import "EditProfileViewController.h"
#import <Masonry.h>
#import "ProfileViewController.h"
#import "PureLayout/PureLayout.h"
#import "User.h"
#import "SettingsViewController.h"
#import "UIImageView+Cache.h"

@interface ProfileViewController () <editProfileDelegate>

@property(strong, nonatomic) UIImageView *profilePicture;
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *bioLabel;
@property(strong, nonatomic) UILabel *ageLabel;
@property(strong, nonatomic) UILabel *contactNumberLabel;
@property(strong, nonatomic) UIButton *editProfile;
@property(strong, nonatomic) UIButton *settingsButton;
@property(strong, nonatomic) User *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // set the database reference
    FIRDatabaseReference *reference = [[FIRDatabase database]reference];
    FIRDatabaseHandle *databaseHandle = [[[reference child:@"Users"]child:[FIRAuth auth].currentUser.uid]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *usersDictionary = snapshot.value;
        if (![snapshot.value isEqual:[NSNull null]]) {
            self.user = [[User alloc] initFromDatabase:usersDictionary];
            [self didUpdateProfile];
            
            if ([self.user.biography isEqualToString:@"nil"]) {
                self.bioLabel.text = @"No biography available";
                [self.bioLabel sizeToFit];
            }
            
            if (![self.user.profilePicURL isEqualToString:@"nil"]){
                [self.profilePicture loadURLandCache:self.user.profilePicURL];
            }
        }
        else {
            FIRDatabaseReference *userRef = [[reference child:@"Users"]child:[FIRAuth auth].currentUser.uid];
            [userRef setValue:@{@"Age":@(0), @"Bio":@"nil", @"Name":[FIRAuth auth].currentUser.displayName,@"PhoneNumber":@(0), @"ProfilePicURL":@"nil",@"EventsGoing":@[@"a"]}];
        }
    }];
    [self configureProfile];
    self.navigationItem.title = @"Profile";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureProfile {
    
    self.view.backgroundColor = [UIColor flatWhiteColor];

    if (!self.user) {
        self.user = [[User alloc]init];
        self.user.name = [FIRAuth auth].currentUser.displayName;
        self.user.biography = @"Bio";
    }

    // set up the profile picture field
    self.profilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(150, 30, 100, 100)];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
    self.profilePicture.clipsToBounds = YES;
    self.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
    self.profilePicture.layer.borderWidth = 2;
    self.profilePicture.layer.borderColor = UIColor.flatPinkColor.CGColor;
    [self.profilePicture setImage:[UIImage imageNamed:@"profile-blank"]];
    
    //set up the name label field
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 140, 30, 30)];
    self.nameLabel.text = @"Name";
    [self.nameLabel sizeToFit];
    
    // set up the bio field
    self.bioLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 170, 200, 50)];
    self.bioLabel.text = @"Bio";
    [self.bioLabel sizeToFit];
    
    UIBarButtonItem *editProfile = [[UIBarButtonItem alloc] init];
    [editProfile setTitle:@"Edit Profile"];
    self.navigationItem.rightBarButtonItem = editProfile;
    editProfile.target = self;
    editProfile.action = @selector(didTapEditProfile);
    
    // set up the edit profile button
    /*self.editProfile = [[UIButton alloc]initWithFrame:CGRectMake(150, 200, 70, 30)];
    self.editProfile.layer.cornerRadius = 5;
    self.editProfile.layer.borderWidth = 2;
    self.editProfile.layer.borderColor = UIColor.flatPinkColor.CGColor;
    [self.editProfile setTitle:@"Edit Profile" forState:UIControlStateNormal];
    [self.editProfile setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.editProfile sizeToFit];
    [self.editProfile addTarget:self action:@selector(didTapEditProfile) forControlEvents:UIControlEventTouchUpInside];*/
    
    // set up settings button
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc]init];
    [settingsButton setImage:[UIImage imageNamed:@"settings"]];
    self.navigationItem.leftBarButtonItem = settingsButton;
    settingsButton.target = self;
    settingsButton.action = @selector(didTapSettings);
    
    self.settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 205, 30, 30)];
    [self.settingsButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [self.settingsButton sizeToFit];
    [self.settingsButton addTarget:self action:@selector(didTapSettings) forControlEvents:UIControlEventTouchUpInside];
    
    //convert age to a string
    if (![self.user.age isEqualToNumber:@(0)]){
        NSNumber *userAge = self.user.age;
        NSString *ageInString = [userAge stringValue];
        self.ageLabel.text = ageInString;
    }
    
    //set up the age field
    self.ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 270, 30, 30)];
    self.ageLabel.text = @"Age";
    [self.ageLabel sizeToFit];
    
    // set up the phone number field
    self.contactNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 300, 30, 30)];
    self.contactNumberLabel.text = @"Phone number";
    [self.contactNumberLabel sizeToFit];
    
    // add all subviews to the view
    [self.view addSubview:self.profilePicture];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.ageLabel];
    [self.view addSubview:self.contactNumberLabel];
    [self.view addSubview:self.bioLabel];
    //[self.view addSubview:self.editProfile];
   // [self.view addSubview:self.settingsButton];
}

- (void)didTapEditProfile {
    EditProfileViewController *newProfile = [[EditProfileViewController alloc] init];
    [self.navigationController pushViewController:newProfile animated:YES];
}

- (void)didTapSettings {
    SettingsViewController *settings = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settings animated:YES];
}

- (void)didUpdateProfile {
    self.nameLabel.text = self.user.name;
    self.bioLabel.text = self.user.biography;
    NSNumber *ageNumber = self.user.age;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    NSString *ageString = [formatter stringFromNumber:ageNumber];
    self.ageLabel.text = ageString;
    
  
    //convert phone number to a string
    if (![self.user.phoneNumber isEqualToNumber:@(0)]){
        NSNumber *userNumber = self.user.phoneNumber ;
        NSString *phoneNumberInString = [userNumber stringValue];
        self.contactNumberLabel.text = phoneNumberInString;
    }
    
    [self.nameLabel sizeToFit];
    [self.bioLabel sizeToFit];
    [self.contactNumberLabel sizeToFit];
    [self.ageLabel sizeToFit];
}

@end
