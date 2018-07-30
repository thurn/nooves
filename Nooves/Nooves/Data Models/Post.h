#import <FirebaseDatabase/FirebaseDatabase.h>
#import <Foundation/Foundation.h>

@interface Post : NSObject

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
@property (nonatomic) NSString *activityTitle;
@property (nonatomic) NSString *activityDescription;
@property (nonatomic) NSDate *activityDateAndTime;
@property (nonatomic) FIRDatabaseReference *ref;
@property (nonatomic) NSNumber *activityLat;
@property (nonatomic) NSNumber *activityLng;
@property (nonatomic) NSString *fireBaseID;
@property (nonatomic) NSString *userID;

+ (NSString *)activityTypeToString:(ActivityType) activityType;
- (instancetype)initPostWithDetails:(NSDate *)eventDate
                          withTitle:(NSString *) postTitle
                    withDescription:(NSString *) postDescription
                           withType:(ActivityType ) activityType
                            withLat:(NSNumber *) lat
                            withLng:(NSNumber *) lng
                             withID:(NSString *)postID;
+ (void)postToFireBase:(Post *)post;
- (void)initFromFirebase;
+ (NSArray *)readPostsFromFIRDict:(NSDictionary *)postsDict;
@end
