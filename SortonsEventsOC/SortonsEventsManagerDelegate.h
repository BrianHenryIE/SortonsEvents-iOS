//
//  SortonsEventsManagerDelegate.h
//  DublinTheatreOC
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//



@protocol SortonsEventsManagerDelegate
- (void)didReceiveDiscoveredEvents:(NSArray *)groups;
- (void)fetchingDiscoveredEventsFailedWithError:(NSError *)error;
@end
