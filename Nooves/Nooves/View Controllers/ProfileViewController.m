#import "EditProfileViewController.h"
#import "ProfileViewController.h"
#import "PureLayout/PureLayout.h"

@interface ProfileViewController () <editProfileDelegate>

@property(strong, nonatomic) UIImageView *profilePicture;
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *bioLabel;
@property(strong, nonatomic) UIButton *editProfile;
@property(nonatomic) User *user;

@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureProfile];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Profile";
    
    if (!self.usersArray) {
        self.usersArray = [[NSMutableArray alloc]init];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)configureProfile {
    
    // set up the profile picture field
    self.profilePicture = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 100, 100)];
    [self.profilePicture setImage:[UIImage imageNamed:@"profile-blank"]];
    [self.profilePicture sizeToFit];
    
    
    //set up the name label field
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 80, 30, 30)];
    self.nameLabel.text = @"Name";
    [self.nameLabel sizeToFit];
    
    // set up the bio field
    self.bioLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 200, 50)];
    self.bioLabel.text = @"Bio";
    [self.bioLabel sizeToFit];
    
    // set up the edit profile button
    self.editProfile = [[UIButton alloc]initWithFrame:CGRectMake(150, 200, 30, 30)];
    [self.editProfile setTitle:@"Edit Profile" forState:UIControlStateNormal];
    [self.editProfile setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.editProfile sizeToFit];
    [self.editProfile addTarget:self action:@selector(didTapEditProfile) forControlEvents:UIControlEventTouchUpInside];
    
    // add all subviews to the view
    [self.view addSubview:self.profilePicture];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.bioLabel];
    [self.view addSubview:self.editProfile];    
}

- (void)didTapEditProfile {
    EditProfileViewController *newProfile = [[EditProfileViewController alloc]init];
    [self.navigationController pushViewController:newProfile animated:YES];
}

- (void)didUpdateProfile:(User *)user {
    self.user = user;
    self.nameLabel.text = user.name;
    self.bioLabel.text = user.biography;
    //[self.view reloadInputViews];
    NSLog(@"profile page name: %@", self.nameLabel.text);
    NSLog(@"profile page bio: %@", self.bioLabel.text);
    NSLog(@"didupdateProfile was called");
}



@end
