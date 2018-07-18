//
//  ActivityType.h
//  Nooves
//
//  Created by Nkenna Aniedobe on 7/17/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#ifndef ActivityType_h
#define ActivityType_h
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
NSString * ActivityTypeToString(ActivityType activityType){
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
#endif /* ActivityType_h */
