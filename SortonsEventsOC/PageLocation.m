//
//  PageLocation.m
//  Belfield
//
//  Created by Brian Henry on 20/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import "PageLocation.h"

@implementation PageLocation

- (id)init {
    self = [super init];
    if (self) {
        // self.head = nil;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    // PageLocation *pl = [super init];
    self = [self init];
    if (self) {
        
        self.street = [dictionary valueForKey:@"street"];
        self.city = [dictionary valueForKey:@"city"];
        self.country = [dictionary valueForKey:@"country"];
        self.zip = [dictionary valueForKey:@"zip"];
        self.latitude = [(NSNumber*) [dictionary valueForKey:@"latitude"] doubleValue];
        self.longitude = [(NSNumber*) [dictionary valueForKey:@"longitude"] doubleValue];
        self.friendlyString = [dictionary valueForKey:@"friendlyString"];
        
    }
    return self;
}

@end
