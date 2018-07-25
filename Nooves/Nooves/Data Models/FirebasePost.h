//
//  FirebasePost.h
//  Nooves
//
//  Created by Nkenna Aniedobe on 7/18/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
@class Post;
@interface FirebasePost : NSObject
@property (strong, nonatomic) NSNumber *activityType;
@property (strong, nonatomic) NSString *postTitle;
@property (strong, nonatomic) NSString *postDescription;
@property (strong, nonatomic) NSNumber *eventDateAndTime;
@property (nonatomic) NSNumber *location;
-(instancetype)initWithPost:(Post *)post;
@end
