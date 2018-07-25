//
//  FirebasePost.m
//  Nooves
//
//  Created by Nkenna Aniedobe on 7/18/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "FirebasePost.h"

@implementation FirebasePost
-(instancetype)initWithPost:(Post *)post{
    FirebasePost *firePost = [[FirebasePost alloc]init];
    int timestamp = [post getDateTimeStamp];
    firePost.eventDateAndTime = @(timestamp);
    firePost.postTitle = post.activityTitle;
    firePost.postDescription = post.activityDescription;
    NSNumber *eventType = [post ActivityTypeToNumber];
    firePost.activityType = eventType;
    firePost.location = post.activityLat;
    return firePost;
}

@end
