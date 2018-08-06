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
        self.usersGoing = @[[FIRAuth auth].currentUser.uid];
        self.activityLocation = location;
    }
    return self;
}

- (void)initFromFirebase {
}

+ (void)postToFireBase:(Post *)post {
    int timestamp = [post.activityDateAndTime timeIntervalSince1970];
    NSNumber *dateAndTimeStamp = @(timestamp);
    NSNumber *activityType = @(post.activityType);
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    FIRDatabaseReference *reffy = [[[ref child:@"Posts"] child:[FIRAuth auth].currentUser.uid] childByAutoId];
    [reffy setValue:@{@"Date":dateAndTimeStamp, @"Title":post.activityTitle, @"Activity Type":activityType, @"Description":post.activityDescription, @"Latitude":post.activityLat, @"Longitude":post.activityLng, @"UsersGoing":post.usersGoing, @"Location":post.activityLocation}];
}

+ (NSArray *)readPostsFromFIRDict:(NSDictionary *)postsDict {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for(NSString *userKey in postsDict) {
        for(NSString *IDKey in postsDict[userKey]) {
            Post *posty = [[Post alloc]init];
            posty.fireBaseID = IDKey;
            FIRDatabaseReference *myRef = [[[[FIRDatabase database] reference] child:@"Users"] child:userKey];
            [myRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary *dict = snapshot.value;
                if (![dict isEqual:[NSNull null]]) {
                    NSArray *myArray = dict[@"EventsGoing"];
                    if (![myArray containsObject:posty.fireBaseID]) {
                        NSMutableArray *goingArrray = [NSMutableArray arrayWithArray:myArray];
                        [goingArrray addObject:posty.fireBaseID];
                        myArray = [NSArray arrayWithArray:goingArrray];
                        [myRef updateChildValues:@{@"EventsGoing":myArray}];
                    }
                }
            }];
            
            posty.activityTitle = postsDict[userKey][IDKey][@"Title"];
            posty.activityDescription = postsDict[userKey][IDKey][@"Description"];
            posty.userID = userKey;
            posty.activityLat = postsDict[userKey][IDKey][@"Latitude"];
            posty.activityLng = postsDict[userKey][IDKey][@"Longitude"];
            posty.activityLocation = postsDict[userKey][IDKey][@"Location"];
            ActivityType type = [postsDict[userKey][IDKey][@"Activity Type"] integerValue];
            posty.activityType = type;
            posty.usersGoing = [postsDict[userKey][IDKey][@"UsersGoing"] copy];
            NSInteger date = [postsDict[userKey][IDKey][@"Date"] integerValue];
            NSDate *daty = [NSDate dateWithTimeIntervalSince1970:date];
            posty.activityDateAndTime = daty;
            [tempArray addObject:posty];
        }
    }
    return tempArray;
}

@end
