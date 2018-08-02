#import "CategoryPickerModalViewController.h"
#import "Post.h"

@interface CategoryPickerModalViewController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic) NSArray *categories;
@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic) UILabel *categoryLabel;
@end

@implementation CategoryPickerModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = NO;
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    
    self.categoryLabel = [[UILabel alloc] init];
    self.categoryLabel.frame = CGRectMake(10, 500, 100, 100);
    
    UIButton *selectedCategory = [self selectCategory];
    selectedCategory.frame = CGRectMake(10.0, 250.0, 20, 30);
    [selectedCategory sizeToFit];
    
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.categoryLabel];
    [self.view addSubview:selectedCategory];
    [self createBackButton];
}

// opens category picker view
- (UIButton *)selectCategory{
    UIButton *selectCategory = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectCategory setTitle:@"Select category" forState:UIControlStateNormal];
    [selectCategory addTarget:self
                       action:@selector(didTapSelectCategory)
             forControlEvents:UIControlEventTouchUpInside];
    [selectCategory sizeToFit];
    return selectCategory;
}

// passes post data and jumps back to composer view controller
- (void)didTapSelectCategory{
    
    [self.categoryDelegate categoryPickerModalViewController:self
                                         didPickActivityType:(ActivityType *)self.activityType];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

// returns the picker view column size
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the array count to determine rows in picker view
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    
    return ActivityTypeOther+1;
}

// returns the array element at each row
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    return [Post activityTypeToString:row];
}

// assigns the selected category from picker view to label and activity type
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
                                               inComponent:(NSInteger)component {

    self.categoryLabel.text = [Post activityTypeToString:row];
    self.activityType = row;
}

// back button
- (UIBarButtonItem *)createBackButton {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"back-icon"]
                                           style:UIBarButtonItemStylePlain
                                          target:self
                                         action:@selector(didTapBackButton)];
    self.navigationItem.leftBarButtonItem = backButton;
    return backButton;
}

// goes back to parent contoller
- (void)didTapBackButton {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
