//
//  DiscoveredEvent.h
//  DublinTheatreOC
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoveredEvent : NSObject

@property (strong, nonatomic) NSString *eid;

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *startTime;

@property BOOL isDateOnly;

@property (strong, nonatomic) NSString *location;

@end
