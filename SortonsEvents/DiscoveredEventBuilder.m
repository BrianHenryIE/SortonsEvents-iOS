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
    // NSLog(@"Count %lu", (unsigned long)results.count);
    
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    
    // For each object in the array of resutls
    for (NSDictionary *discoveredEventsDic in results) {
        
        // Prepare object
        DiscoveredEvent *discoveredEvent = [[DiscoveredEvent alloc] init];
        
        discoveredEvent.eventId = [discoveredEventsDic valueForKey:@"eventId"];

        discoveredEvent.clientId = [discoveredEventsDic valueForKey:@"clientId"];
        
        discoveredEvent.name = [discoveredEventsDic valueForKey:@"name"];
        
        discoveredEvent.location = [discoveredEventsDic valueForKey:@"location"];

        discoveredEvent.startTime = [dateFormat dateFromString:[discoveredEventsDic valueForKey:@"startTime"]];

        discoveredEvent.isDateOnly =  [[discoveredEventsDic valueForKey:@"dateOnly"] boolValue];
        
        [discoveredEvents addObject:discoveredEvent];
        
    }
    
    return discoveredEvents;
}


@end
