#import "EditProfileViewController.h"
#import "ProfileViewController.h"
#import "PureLayout/PureLayout.h"

@interface ProfileViewController ()

@property(strong, nonatomic) UIImageView *profilePicture;
@property(strong, nonatomic) UILabel *nameLabel;
@property(strong, nonatomic) UILabel *bio;
@property(strong, nonatomic) UIButton *editProfile;

@end

@implementation ProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureProfile];
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
    self.bio = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 200, 50)];
    self.bio.text = @"Bio";
    [self.bio sizeToFit];
    
    // set up the edit profile button
    self.editProfile = [[UIButton alloc]initWithFrame:CGRectMake(150, 200, 30, 30)];
    [self.editProfile setTitle:@"Edit Profile" forState:UIControlStateNormal];
    [self.editProfile setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.editProfile sizeToFit];
    [self.editProfile addTarget:self action:@selector(didTapEditProfile) forControlEvents:UIControlEventTouchUpInside];
    
    // add all subviews to the view
    [self.view addSubview:self.profilePicture];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.bio];
    [self.view addSubview:self.editProfile];
    
}

- (void)didTapEditProfile {
    EditProfileViewController *newProfile = [[EditProfileViewController alloc]init];
    [self.navigationController pushViewController:newProfile animated:YES];
}


@end
