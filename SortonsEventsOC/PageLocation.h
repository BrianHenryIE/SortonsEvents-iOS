//
//  PageLocation.h
//  Belfield
//
//  Created by Brian Henry on 20/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageLocation : NSObject

-(id)init;
-(id)initWithDictionary:(NSDictionary *)dictionary;

@property (strong, nonatomic) NSString* street;
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* zip;
@property double latitude;
@property double longitude;
@property (strong, nonatomic) NSString* friendlyString;

@end
