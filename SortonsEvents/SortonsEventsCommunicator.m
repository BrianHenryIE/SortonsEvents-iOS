//
//  SortonsEventsCommunicator.m
//  DublinTheatreOC
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//

#import "SortonsEventsCommunicator.h"
#import "SortonsEventsCommunicatorDelegate.h"
#import "fomo.h"



@implementation SortonsEventsCommunicator

- (void)getDiscoveredEvents
{
    NSString *urlAsString = [NSString stringWithFormat:@"https://sortonsevents.appspot.com/_ah/api/upcomingEvents/v1/discoveredeventsresponse/%@", @"428055040731753"];
    
    // 632419800128560 Dublin Theatre
    // 197528567092983 UCD Events
    
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    
    //NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingDiscoveredEventsFailedWithError:error];
        } else {
            [self.delegate receivedDiscoveredEventsJSON:data];
        }
    }];
}


@end
