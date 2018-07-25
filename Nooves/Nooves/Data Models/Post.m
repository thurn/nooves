//
//  Post.m
//  Nooves
//
//  Created by Norette Ingabire on 7/16/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "Post.h"
#import <FIRDatabase.h>
@implementation Post

+ (NSString *)activityTypeToString:(ActivityType) activityType{
    switch (activityType) {
        case Outdoors:
            return @"Outdoors";
        case Shopping:
            return @"Shopping";
        case Partying:
            return @"Partying";
        case Eating:
            return @"Eating";
        case Arts:
            return @"Arts";
        case Sports:
            return @"Sports";
        case Networking:
            return @"Networking";
        case Fitness:
            return @"Fitness";
        case Games:
            return @"Games";
        case Concert:
            return @"Concert";
        case Cinema:
            return @"Cinema";
        case Festival:
            return @"Festival";
        default:
            return @"Other";
    }
};
+ (ActivityType)stringToActivityType:(NSString *)activityString{
    if([activityString isEqualToString:@"Outdoors"]){
        return Outdoors;
    }
    else if([activityString isEqualToString:@"Shopping"]){
        return Shopping;
    }
    else if([activityString isEqualToString:@"Partying"]){
        return Partying;
    }
    else if([activityString isEqualToString:@"Eating"]){
        return Eating;
    }
    else if([activityString isEqualToString:@"Arts"]){
        return Arts;
    }
    else if([activityString isEqualToString:@"Sports"]){
        return Sports;
    }
    else if([activityString isEqualToString:@"Networking"]){
        return Networking;
    }
    else if([activityString isEqualToString:@"Fitness"]){
        return Fitness;
    }
    else if([activityString isEqualToString:@"Games"]){
        return Games;
    }
    else if([activityString isEqualToString:@"Concert"]){
        return Concert;
    }
    else if([activityString isEqualToString:@"Cinema"]){
        return Cinema;
    }
    else if([activityString isEqualToString:@"Festival"]){
        return Festival;
    }
    return Other;
}


-(instancetype)MakePost:(NSDate *)eventDate withTitle:(NSString *) postTitle withDescription:(NSString *) postDescription withType:(ActivityType ) activityType{
    Post *post = [[Post alloc]init];
    post.activityDateAndTime = eventDate;
    post.activityTitle = postTitle;
    post.activityDescription = postDescription;
    post.activityType = activityType;
    return post;
}

+ (void)postToFireBase:(Post *)post{
    int timestamp = [post.activityDateAndTime timeIntervalSince1970];
    NSNumber *dateAndTimeStamp = @(timestamp);
    NSNumber *activityType = @(post.activityType);
    post.ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *ref = [[post.ref child:@"Posts"] childByAutoId];
    [ref setValue:@{@"Date": dateAndTimeStamp, @"Title":post.activityTitle, @"Activity Type":activityType, @"Description":post.activityDescription}];
}
@end
