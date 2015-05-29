//
//  IncludedPage.m
//  Belfield
//
//  Created by Brian Henry on 20/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import "IncludedPage.h"

@implementation IncludedPage


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.name = [dictionary valueForKey:@"name"];
        
        self.pageId = [dictionary valueForKey:@"pageId"];
        
        self.pageUrl = [dictionary valueForKey:@"pageUrl"];
        
        self.location = [[PageLocation alloc] initWithDictionary:[dictionary objectForKey:@"location"]];
        
    }
    return self;
}

@end
