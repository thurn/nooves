//
//  EditProfileViewController.h
//  Nooves
//
//  Created by Norette Ingabire on 7/25/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@protocol editProfileDelegate
- (void)didUpdateProfile:(User *) user;
@end

@interface EditProfileViewController : UIViewController

@property(nonatomic) User *user;
@property(nonatomic) NSMutableArray *usersArray;
@property(nonatomic, weak) id<editProfileDelegate> delegate;

@end
