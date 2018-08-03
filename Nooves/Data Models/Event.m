//
//  Event.m
//  Nooves
//
//  Created by Norette Ingabire on 8/2/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import "Event.h"

@implementation Event

- (instancetype) initEventWithDetails:(NSDate *)activityTime
                            withTitle:(NSString *)activityTitle
                      withDescription:(NSString *)activityDescription
                         withLocation:(NSString *)activityLocation
                            withVenue:(NSString *)place {
    self = [super init];
    
    if(self) {
        self.eventTime = activityTime;
        self.eventTitle = activityTitle;
        self.eventDescription = activityDescription;
        self.eventLocation = activityLocation;
        self.venue = place;
    }
    return self;
}

@end
