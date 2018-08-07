#import "EventDetailsViewController.h"
#import <PureLayout.h>

@interface EventDetailsViewController ()

@property(strong, nonatomic) UILabel *titleField;
@property(strong, nonatomic) UILabel *descriptionField;
@property(strong, nonatomic) UILabel *venueField;
@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureEventDetails];
}

- (void)configureEventDetails {
    self.titleField = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 500, 50)];
    self.titleField.text = self.event[@"title"];
    [self.titleField setFont:[UIFont fontWithName:@"Arial-Boldmt" size:20]];
    [self.titleField sizeToFit];
    [self.view addSubview:self.titleField];
    
    self.descriptionField = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 400, 300)];
    [self.descriptionField setNumberOfLines:0];
    //[descriptionField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleField withOffset:30.0f];
    NSString *descriptionText = self.event[@"description"];
    if([descriptionText isKindOfClass:[NSString class]]) {
        self.descriptionField.text = descriptionText;
    }
    
    else {
        self.descriptionField.text = @"No description available for this event";
    }
    
    [self.descriptionField sizeToFit];
    [self.view addSubview:self.descriptionField];
    
   self.venueField = [[UILabel alloc]initWithFrame:CGRectMake(50, 500, 200, 50)];
   // [venueField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:descriptionField withOffset:80.0f];
    self.venueField.text = self.event[@"venue_name"];
    [self.venueField sizeToFit];
    [self.view addSubview:self.venueField];
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]init];
    [confirmButton setTitle:@"Post event"];
    self.navigationItem.rightBarButtonItem = confirmButton;
    confirmButton.target = self;
    confirmButton.action = @selector(didTapConfirm);
}

- (void)didTapConfirm {
    NSLog(@"Confirmed cell");
   // [self.locEventsDelegate eventDetailsViewController:self didSelectEventWithTitle:self.titleField.text withDescription:self.descriptionField.text withVenue:self.venueField.text];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
