#import "CategoryPickerModalViewController.h"
#import "Post.h"
#import "Chameleon.h"

@interface CategoryPickerModalViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIScrollViewDelegate>
@property (nonatomic) NSArray *categories;
@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSMutableArray *imagesArray;
@end

@implementation CategoryPickerModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor flatWhiteColor];
    self.navigationController.navigationBarHidden = NO;
    
    self.imagesArray = [[NSMutableArray alloc] init];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.frame = CGRectMake(0, 51, self.view.frame.size.width, 100);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    int xOffset = 0;
    for(int index=0; index < [self.imagesArray count]; index++)
    {

        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset,10,160, 110)];
        img.image = (UIImage*) [self.imagesArray objectAtIndex:index];

        [self.scrollView addSubview:img];

        xOffset+=100;
    }
    
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(100+xOffset,110);
    
    [self.view addSubview:self.pickerView];
    [self createBackButton];
    [self createConfirmButton];
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

// confirm button
- (UIBarButtonItem *)createConfirmButton {
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(didTapConfirmButton)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    return confirmButton;
}

// passes post data and jumps back to composer view controller
- (void)didTapConfirmButton {
    [self.categoryDelegate categoryPickerModalViewController:self
                                         didPickActivityType:(ActivityType *)self.activityType];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UIPickerViewDelegate

// assigns the selected category from picker view to activity type
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    self.activityType = row;
}

// returns the array element at each row
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    return [Post activityTypeToString:row];
}

#pragma mark - UIPickerViewDataSource

// returns the picker view column size
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the array count to determine rows in picker view
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return ActivityTypeOther+1;
}

@end
