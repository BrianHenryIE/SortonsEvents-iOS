//
//  SortonsEventsManager.h
//  DublinTheatreOC
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SortonsEventsManagerDelegate.h"
#import "SortonsEventsCommunicatorDelegate.h"

@class SortonsEventsCommunicator;

@interface SortonsEventsManager : NSObject<SortonsEventsCommunicatorDelegate>

@property (strong, nonatomic) SortonsEventsCommunicator *communicator;
@property (weak, nonatomic) id<SortonsEventsManagerDelegate> delegate;

- (void)fetchDiscoveredEvents;

@end