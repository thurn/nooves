#import "CategoryPickerModalViewController.h"
#import "ComposeViewController.h"

@interface CategoryPickerModalViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) NSArray *categories;
@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic) UILabel *categoryLabel;

@end

@implementation CategoryPickerModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // set controller view properties
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;

    // TODO(Nikki): directly use firebase array of categories
    self.categories = @[@"Outdoors", @"Shopping", @"Partying", @"Eating", @"Arts", @"Sports", @"Networking", @"Fitness", @"Games", @"Concert", @"Cinema", @"Festival", @"Other"];
    
    // instantiate picker view
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    
    // set up properties for category display label
    self.categoryLabel = [[UILabel alloc] init];
    self.categoryLabel.frame = CGRectMake(10, 500, 100, 100);
    
    // set up properties for button
    UIButton *selectedCategory = [self selectCategory];
    selectedCategory.frame = CGRectMake(10.0, 250.0, 20, 30);
    [selectedCategory sizeToFit];
    
    // add components to view
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.categoryLabel];
    [self.view addSubview:selectedCategory];
    
    [self goBack];
}

- (void)viewWillAppear: (BOOL)animated {
    self.hidesBottomBarWhenPushed = YES;
}

// opens category picker view
- (UIButton *)selectCategory{
    UIButton *selectCategory = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectCategory setTitle:@"Select category" forState:UIControlStateNormal];
    [selectCategory addTarget:self action:@selector(didTapSelectCategory) forControlEvents:UIControlEventTouchUpInside];
    [selectCategory sizeToFit];
    return selectCategory;
}

// passes post data and jumps back to composer view controller
- (void)didTapSelectCategory{
    
    [self.categoryDelegate categoryPickerModalViewController:self didPickActivityType:(ActivityType *)self.activityType];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

// returns the picker view column size
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the array count
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return self.categories.count;
}

// returns the array at each row
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.categories[row];
}

// assigns the selected category from picker view to label and activity type
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.categoryLabel.text = self.categories[row];
    ActivityType type = [Post stringToActivityType:self.categoryLabel.text];
    self.activityType = type;
}

// back button
- (UIBarButtonItem *)goBack {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back-icon"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(didTapBack)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    return backButton;
}

// goes back to parent contoller
- (void)didTapBack {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
