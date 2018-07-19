//
//  postCell.h
//  Nooves
//
//  Created by Norette Ingabire on 7/16/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface postCell : UITableViewCell

- (void) setPost: (Post *) post;

@property (strong, nonatomic) UILabel *postField;

@end
