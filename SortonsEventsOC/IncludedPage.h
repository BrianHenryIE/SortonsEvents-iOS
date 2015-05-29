//
//  IncludedPage.h
//  Belfield
//
//  Created by Brian Henry on 20/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PageLocation.h"

@interface IncludedPage : NSObject

-(id)initWithDictionary:(NSDictionary *)dictionary;

@property (strong, nonatomic) PageLocation* location;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* page_id;
@property (strong, nonatomic) NSString* page_url;
@property (strong, nonatomic) NSString* pageUrl;
@property (strong, nonatomic) NSString* pageId;

@end
