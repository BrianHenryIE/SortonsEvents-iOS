//
//  SortonsEventsCommunicator.h
//  DublinTheatreOC
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SortonsEventsCommunicatorDelegate;

@interface SortonsEventsCommunicator : NSObject
@property (weak, nonatomic) id<SortonsEventsCommunicatorDelegate> delegate;

- (void)getDiscoveredEvents;

@end

