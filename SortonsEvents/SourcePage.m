//
//  IncludedPage.m
//  Belfield
//
//  Created by Brian Henry on 20/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import "SourcePage.h"

@implementation SourcePage


-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.name = [dictionary valueForKey:@"name"];
        
        self.pageId = [dictionary valueForKey:@"pageId"];
        
        self.pageUrl = [[dictionary valueForKey:@"pageUrl"] stringByReplacingOccurrencesOfString:@"http:" withString:@"https:"];
       
        self.about = [dictionary valueForKey:@"about"];
        
        self.street = [dictionary valueForKey:@"street"];
        self.city = [dictionary valueForKey:@"city"];
        self.country = [dictionary valueForKey:@"country"];
        self.zip = [dictionary valueForKey:@"zip"];
        self.latitude = [(NSNumber*) [dictionary valueForKey:@"latitude"] doubleValue];
        self.longitude = [(NSNumber*) [dictionary valueForKey:@"longitude"] doubleValue];
        self.friendlyLocationString = [dictionary valueForKey:@"friendlyLocationString"];
        
    }
    return self;
}

@end
