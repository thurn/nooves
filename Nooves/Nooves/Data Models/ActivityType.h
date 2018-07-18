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
    Shopping,
    Partying,
    Eating,
    Cinema,
    Festival,
    Other
};
(NSString*)ConvertActivityToString(ActivityType activityType){
    switch (activityType) {
        case Outdoors:
            return @"Outdoors";
        case Shopping:
            return @"Shopping";
        case Partying:
            return @"Partying";
        case Eating:
            return @"Eating";
        case Cinema:
            return @"Cinema";
        case Festival:
            return @"Festival";
        default:
            return @"Other";
    }
};
#endif /* ActivityType_h */
