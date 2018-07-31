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
@property(strong, nonatomic) User *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set the database reference
    FIRDatabaseReference *reference = [[FIRDatabase database]reference];
    FIRDatabaseHandle *databaseHandle = [[[reference child:@"Users"]child:[FIRAuth auth].currentUser.uid]observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *usersDictionary= snapshot.value;
        if (![snapshot.value isEqual:[NSNull null]]) {
            self.user = [[User alloc] initFromDatabase:usersDictionary];
            [self didUpdateProfile];
            if (![self.user.profilePicURL isEqualToString:@"nil"]){
                NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:self.user.profilePicURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if(error){
                        NSLog(@"%@", error);
                        return;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.profilePicture.image = [UIImage imageWithData:data];
                    });
                }];
                [task resume];
            }
        }
        else {
            FIRDatabaseReference *userRef = [[reference child:@"Users"]child:[FIRAuth auth].currentUser.uid];
            [userRef setValue:@{@"Age":@(0), @"Bio":@"nil", @"Name":[FIRAuth auth].currentUser.displayName,@"PhoneNumber":@(0), @"ProfilePicURL":@"nil"}];
        }
    }];
    [self configureProfile];
    self.navigationItem.title = @"Profile";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureProfile {
    // set the background color
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (!self.user) {
        self.user = [[User alloc]init];
        self.user.name = [FIRAuth auth].currentUser.displayName;
        self.user.biography = @"Bio";
    }
    
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

- (void)didUpdateProfile {
    self.nameLabel.text = self.user.name;
    self.bioLabel.text = self.user.biography;
    
    //convert age to a string
    if (![self.user.age isEqualToNumber:@(0)]){
        NSNumber *userAge = self.user.age;
        NSString *ageInString = [userAge stringValue];
        self.ageLabel.text = ageInString;
    }
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
