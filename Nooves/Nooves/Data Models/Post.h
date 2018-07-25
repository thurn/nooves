//
//  Post.h
//  Nooves
//
//  Created by Norette Ingabire on 7/16/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseDatabase/FirebaseDatabase.h>
@interface Post : NSObject
typedef NS_ENUM(NSInteger, ActivityType){
    Outdoors,
    Arts,
    Sports,
    Shopping,
    Partying,
    Networking,
    Fitness,
    Games,
    Eating,
    Cinema,
    Festival,
    Concert,
    Other
};

@property (nonatomic) ActivityType activityType;
@property (strong, nonatomic) NSString *activityTitle;
@property (strong, nonatomic) NSString *activityDescription;
@property (strong, nonatomic) NSDate *activityDateAndTime;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (nonatomic) NSString *activityLat;
@property (nonatomic) NSString *activityLng;
@property (strong, nonatomic) NSString *fireBaseID;

+ (NSString *)activityTypeToString:(ActivityType) activityType;
+ (ActivityType)stringToActivityType:(NSString *)activityString;
- (instancetype)initPostWithDetails:(NSDate *)eventDate withTitle:(NSString *) postTitle withDescription:(NSString *) postDescription withType:(ActivityType ) activityType;
+ (void)postToFireBase:(Post *)post;
- (void)initFromFirebase;
@end
