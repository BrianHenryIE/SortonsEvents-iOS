//
//  SortonsEventsCommunicatorDelegate.h
//  DublinTheatreOC
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SortonsEventsCommunicatorDelegate
- (void)receivedDiscoveredEventsJSON:(NSData *)objectNotation;
- (void)fetchingDiscoveredEventsFailedWithError:(NSError *)error;
@end    