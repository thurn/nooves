#import <FirebaseDatabase.h>
#import <Foundation/Foundation.h>

@interface Post : NSObject

// TODO: typedef should be outside of class
typedef NS_ENUM(NSInteger, ActivityType){
    ActivityTypeOutdoors,
    ActivityTypeArts,
    ActivityTypeSports,
    ActivityTypeShopping,
    ActivityTypePartying,
    ActivityTypeNetworking,
    ActivityTypeFitness,
    ActivityTypeGames,
    ActivityTypeEating,
    ActivityTypeCinema,
    ActivityTypeFestival,
    ActivityTypeConcert,
    ActivityTypeOther
};

@property (nonatomic) ActivityType activityType;
@property (strong, nonatomic) NSString *activityTitle;
@property (strong, nonatomic) NSString *activityDescription;
@property (strong, nonatomic) NSDate *activityDateAndTime;
@property (strong, nonatomic) NSNumber *activityLat;
@property (strong, nonatomic) NSNumber *activityLng;
@property (strong, nonatomic) NSString *fireBaseID;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *firstUserGoing;
@property (strong, nonatomic) NSArray *usersGoing;
@property (strong, nonatomic) NSString *activityLocation;
@property (nonatomic) NSInteger timestamp;
+ (NSString *)activityTypeToString:(ActivityType)activityType;
- (instancetype)initPostWithDetails:(NSDate *)eventDate
                          withTitle:(NSString *)postTitle
                    withDescription:(NSString *)postDescription
                           withType:(ActivityType )activityType
                            withLat:(NSNumber *)lat
                            withLng:(NSNumber *)lng
                             withID:(NSString *)postID
                       withLocation:(NSString *)location;
+ (void)postToFireBase:(Post *)post;
- (void)initFromFirebase;
+ (NSArray *)readPostsFromFIRDict:(NSDictionary *)postsDict;
@end
