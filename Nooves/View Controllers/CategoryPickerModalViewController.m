#import "CategoryPickerModalViewController.h"
#import "Post.h"
#import "TapGesture.h"

#import <ChameleonFramework/Chameleon.h>

@interface CategoryPickerModalViewController () <UIScrollViewDelegate>
@property (nonatomic) NSArray *categories;
@property (nonatomic) UIPickerView *pickerView;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) int tappedIndex;
@property (nonatomic) UIImageView *imageView;
@end

@implementation CategoryPickerModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor flatWhiteColor];
    
    [self configureScrollView];
    
    [self createBackButton];
}

- (void)configureScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, 300);
    self.scrollView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2-30);
    self.scrollView.backgroundColor = [UIColor flatWhiteColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    int offset = 0;
    for (int i = 0; i <= 12; i++) {
        float xpos = self.view.frame.size.width/10 + offset;
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:[Post activityTypeToString:i], i]];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xpos, 0, 300, 300)];
        [self.imageView setImage:image];
        [self.imageView setUserInteractionEnabled:YES];
        self.imageView.layer.cornerRadius = 10;
        self.imageView.clipsToBounds = YES;
        
        TapGesture *gest = [[TapGesture alloc] initWithTarget:self action:@selector(didTapImage:)];
        [self.imageView addGestureRecognizer:gest];
        gest.tappedIndex = i;
        
        [self.scrollView addSubview:self.imageView];
        offset += 350;
    }
    
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(100+offset,self.scrollView.frame.size.height);
}

- (void)didTapImage:(UITapGestureRecognizer *)recognizer {
    TapGesture *gest = (TapGesture *)recognizer;
    self.activityType = gest.tappedIndex;
    NSLog(@"%i", gest.tappedIndex);
    [self.categoryDelegate categoryPickerModalViewController:self
                                         didPickActivityType:(ActivityType *)self.activityType];
    [self dismissViewControllerAnimated:NO completion:nil];
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
