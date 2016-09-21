//
//  Fomo.m
//  FOMO UCD
//
//  Created by Brian Henry on 17/08/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import "Fomo.h"

@implementation Fomo

+ (NSString *)fomoId
{

    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSArray *bundleArray = [bundleIdentifier componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];

    NSString *tla = bundleArray[bundleArray.count-1]; // ucd, tcd etc
    
    
    // [NSPropertyListSerialization propertyListWithData:options:format:error:]
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"fomo" ofType:@"plist"];
    NSDictionary *plistDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];

    NSString *fomoId = [plistDict objectForKey:tla];
 
    // return fomoId;
    return @"428055040731753";
    
}

@end
