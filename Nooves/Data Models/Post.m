#import <FIRDatabase.h>
#import <FIRAuth.h>
#import <FirebaseAuth.h>
#import "Post.h"
#import "LoginViewController.h"
@implementation Post

+ (NSString *)activityTypeToString:(ActivityType) activityType{
    switch (activityType) {
        case ActivityTypeOutdoors:
            return @"Outdoors";
        case ActivityTypeShopping:
            return @"Shopping";
        case ActivityTypePartying:
            return @"Partying";
        case ActivityTypeEating:
            return @"Eating";
        case ActivityTypeArts:
            return @"Arts";
        case ActivityTypeSports:
            return @"Sports";
        case ActivityTypeNetworking:
            return @"Networking";
        case ActivityTypeFitness:
            return @"Fitness";
        case ActivityTypeGames:
            return @"Games";
        case ActivityTypeConcert:
            return @"Concert";
        case ActivityTypeCinema:
            return @"Cinema";
        case ActivityTypeFestival:
            return @"Festival";
        default:
            return @"Other";
    }
};

// TODO(Nikki): add user location to this
- (instancetype)initPostWithDetails:(NSDate *)eventDate
                          withTitle:(NSString *)postTitle
                    withDescription:(NSString *) postDescription
                           withType:(ActivityType ) activityType
                            withLat:(NSNumber *) lat
                            withLng:(NSNumber *) lng
                             withID:(NSString *)postID
                       withLocation:(NSString *)location {
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
        self.eventLocation = location;
    }
    return self;
}
- (void)initFromFirebase{
}

// TODO(Nikki): add user location to database
+ (void)postToFireBase:(Post *)post {
    int timestamp = [post.activityDateAndTime timeIntervalSince1970];
    NSNumber *dateAndTimeStamp = @(timestamp);
    NSNumber *activityType = @(post.activityType);
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *reffy = [[[ref child:@"Posts"] child:[FIRAuth auth].currentUser.uid] childByAutoId];
    [reffy setValue:@{@"Date":dateAndTimeStamp, @"Title":post.activityTitle, @"Activity Type":activityType, @"Description":post.activityDescription, @"Latitude":post.activityLat, @"Longitude":post.activityLng, @"Location":post.eventLocation}];
}

// TODO(Nikki): read user location from database
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
            posty.eventLocation = postsDict[userKey][IDKey][@"Location"];
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
