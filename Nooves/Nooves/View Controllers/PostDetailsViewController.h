//
//  PostDetailsViewController.h
//  Nooves
//
//  Created by Nkenna Aniedobe on 7/31/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "User.h"

@interface PostDetailsViewController : UIViewController
- (instancetype)initFromTimeline:(Post *)post;
@end
