//
//  Post.m
//  Nooves
//
//  Created by Norette Ingabire on 7/16/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "Post.h"

@implementation Post
-(NSNumber *)ActivityTypeToNumber{
    NSNumber *activity = @(self.activityType);
    return activity;
}
-(int)getDateTimeStamp{
    int timestamp = [self.activityDateAndTime timeIntervalSince1970];
    return timestamp;
}
-(instancetype)MakePost:(NSDate *)eventDate withTitle:(NSString *) postTitle withDescription:(NSString *) postDescription withType:(ActivityType ) activityType{
    Post *post = [[Post alloc]init];
    post.activityDateAndTime = eventDate;
    post.activityTitle = postTitle;
    post.activityDescription = postDescription;
    post.activityType = activityType;
    return post;
}
@end

