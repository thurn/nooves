//
//  Event.h
//  Nooves
//
//  Created by Norette Ingabire on 8/2/18.
//  Copyright © 2018 Nikki Tran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property(strong, nonatomic) NSString *eventTitle;
@property(strong, nonatomic) NSString *eventDescription;
@property(strong, nonatomic) NSString *eventLocation;
@property(strong,nonatomic) NSString *venue;
@property(strong, nonatomic) NSString *venueAddress;
@property(strong, nonatomic) NSDate *eventTime;

- (instancetype) initEventWithDetails:(NSDate *)activityTime
                            withTitle:(NSString *)activityTitle
                      withDescription:(NSString *)activityDescription
                         withLocation:(NSString *)activityLocation
                            withVenue:(NSString *)place;

@end
