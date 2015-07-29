//
//  DiscoveredEvent.h
//  DublinTheatreOC
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoveredEvent : NSObject

@property (strong, nonatomic) NSString *id;

@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *clientId;

// List<SourcePage> sourcePages

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *location;

@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;

@property BOOL isDateOnly;


@end
