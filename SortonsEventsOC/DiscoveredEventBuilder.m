//
//  DiscoveredEventBuilder.m
//  DublinTheatreOC
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//

#import "DiscoveredEventBuilder.h"
#import "DiscoveredEvent.h"

@implementation DiscoveredEventBuilder

+ (NSArray *)discoveredEventsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *discoveredEvents = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"data"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    // For each object in the array of resutls
    for (NSDictionary *discoveredEventsDic in results) {
        
        // Prepare object
        DiscoveredEvent *discoveredEvent = [[DiscoveredEvent alloc] init];
        
        discoveredEvent.eid = [discoveredEventsDic valueForKey:@"eid"];
        
        discoveredEvent.name = [[discoveredEventsDic valueForKey:@"fbEvent"] valueForKey:@"name"];

        discoveredEvent.startTime = [dateFormat dateFromString:[[discoveredEventsDic valueForKey:@"fbEvent"] valueForKey:@"start_time"]];

        discoveredEvent.isDateOnly =  [[[discoveredEventsDic valueForKey:@"fbEvent"] objectForKey:@"isDateOnly"] boolValue];
        
        discoveredEvent.location = [[discoveredEventsDic valueForKey:@"fbEvent"] valueForKey:@"location"];
        
        [discoveredEvents addObject:discoveredEvent];
        
    }
    
    return discoveredEvents;
}


@end
