//
//  EventDetailsViewController.m
//  Nooves
//
//  Created by Norette Ingabire on 8/7/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "EventDetailsViewController.h"
#import <PureLayout.h>

@interface EventDetailsViewController ()

@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureEventDetails];
}

- (void)configureEventDetails {
    UILabel *titleField = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 500, 50)];
    titleField.text = self.event[@"title"];
    [titleField setFont:[UIFont fontWithName:@"Arial-Boldmt" size:20]];
    [titleField sizeToFit];
    [self.view addSubview:titleField];
    
    UILabel *descriptionField = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 400, 300)];
    [descriptionField setNumberOfLines:0];
    //[descriptionField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleField withOffset:30.0f];
    descriptionField.text = self.event[@"description"];
    [descriptionField sizeToFit];
    [self.view addSubview:descriptionField];
    
    UILabel *venueField = [[UILabel alloc]initWithFrame:CGRectMake(50, 500, 200, 50)];
   // [venueField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:descriptionField withOffset:80.0f];
    venueField.text = self.event[@"venue_name"];
    [venueField sizeToFit];
    [self.view addSubview:venueField];
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]init];
    [confirmButton setTitle:@"Confirm"];
    self.navigationItem.rightBarButtonItem = confirmButton;
    confirmButton.target = self;
    confirmButton.action = @selector(didTapConfirm);
}

- (void)didTapConfirm {
    NSLog(@"Confirmed cell");
}

@end
