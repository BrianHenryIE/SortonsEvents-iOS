//
//  SortonsEventsCommunicator.m
//  DublinTheatreOC
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//

#import "SortonsEventsCommunicator.h"
#import "SortonsEventsCommunicatorDelegate.h"

static NSString *const UCDEVENTS = @"197528567092983";

@implementation SortonsEventsCommunicator

- (void)getDiscoveredEvents
{
    NSString *urlAsString = [NSString stringWithFormat:@"https://sortonsevents.appspot.com/_ah/api/upcomingEvents/v1/discoveredeventsresponse/197528567092983"];
    NSURL *url = [[NSURL alloc] initWithString:urlAsString];
    NSLog(@"%@", urlAsString);
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self.delegate fetchingDiscoveredEventsFailedWithError:error];
        } else {
            [self.delegate receivedDiscoveredEventsJSON:data];
        }
    }];
}


@end
