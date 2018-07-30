#import "Post.h"
#import <FIRDatabase.h>
#import <FIRAuth.h>
#import "LoginViewController.h"
#import <FirebaseAuth.h>
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
+ (ActivityType)stringToActivityType:(NSString *)activityString {
    if([activityString isEqualToString:@"Outdoors"]) {
        return Outdoors;
    }
    else if([activityString isEqualToString:@"Shopping"]) {
        return Shopping;
    }
    else if([activityString isEqualToString:@"Partying"]){
        return Partying;
    }
    else if([activityString isEqualToString:@"Eating"]) {
        return Eating;
    }
    else if([activityString isEqualToString:@"Arts"]) {
        return Arts;
    }
    else if([activityString isEqualToString:@"Sports"]) {
        return Sports;
    }
    else if([activityString isEqualToString:@"Networking"]) {
        return Networking;
    }
    else if([activityString isEqualToString:@"Fitness"]){
        return Fitness;
    }
    else if([activityString isEqualToString:@"Games"]) {
        return Games;
    }
    else if([activityString isEqualToString:@"Concert"]) {
        return Concert;
    }
    else if([activityString isEqualToString:@"Cinema"]) {
        return Cinema;
    }
    else if([activityString isEqualToString:@"Festival"]) {
        return Festival;
    }
    return Other;
}

- (instancetype)initPostWithDetails:(NSDate *)eventDate
                          withTitle:(NSString *)postTitle
                    withDescription:(NSString *) postDescription
                           withType:(ActivityType ) activityType
                            withLat:(NSNumber *) lat
                            withLng:(NSNumber *) lng
                             withID:(NSString *)postID{
    self = [super init];
    if (self){
        self.activityDateAndTime = eventDate;
        self.activityTitle = postTitle;
        self.activityDescription = postDescription;
        self.activityType = activityType;
        self.activityLat = lat;
        self.activityLng = lng;
        self.userID = FIRAuth.auth.currentUser.uid;
        self.fireBaseID = postID;
    }
    return self;
}
- (void)initFromFirebase{
}

+ (void)postToFireBase:(Post *)post {
    int timestamp = [post.activityDateAndTime timeIntervalSince1970];
    NSNumber *dateAndTimeStamp = @(timestamp);
    NSNumber *activityType = @(post.activityType);
    post.ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *ref = [[[post.ref child:@"Posts"] child:[FIRAuth auth].currentUser.uid] childByAutoId];
    [ref setValue:@{@"Date":dateAndTimeStamp, @"Title":post.activityTitle, @"Activity Type":activityType, @"Description":post.activityDescription, @"Latitude":post.activityLat, @"Longitude":post.activityLng}];
}
+ (NSArray *)readPostsFromFIRDict:(NSDictionary *)postsDict{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(NSString *userKey in postsDict){
        for(NSString *IDKey in postsDict[userKey]){
            Post *posty = [[Post alloc]init];
            posty.fireBaseID = IDKey;
            posty.activityTitle = postsDict[userKey][IDKey][@"Title"];
            posty.activityDescription = postsDict[userKey][IDKey][@"Description"];
            posty.userID = userKey;
            posty.activityLat = postsDict[userKey][IDKey][@"Latitude"];
            posty.activityLng = postsDict[userKey][IDKey][@"Longitude"];
            ActivityType type = [postsDict[userKey][IDKey][@"Activity Type"] integerValue];
            posty.activityType = type;
            NSInteger date = [postsDict[userKey][IDKey][@"Date"] integerValue];
            NSDate *daty = [NSDate dateWithTimeIntervalSince1970:date];
            posty.activityDateAndTime = daty;
            [tempArray addObject:posty];
        }
    }
    NSArray *postsArray = [NSArray arrayWithArray:tempArray];
    return postsArray;
}

@end
