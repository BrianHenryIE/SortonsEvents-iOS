//
//  DublinTheatreOCTests.m
//  DublinTheatreOCTests
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "SourcePage.h"
#import "CPDAPIClient.h"

@interface SortonsEventsOCTests : XCTestCase

@end

@implementation SortonsEventsOCTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDateFormatting {
    
    
    
    NSString *deStartTime = @"2015-02-19T00:00:00.000Z";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *startTime = [dateFormat dateFromString:deStartTime];
    
    NSLog(@"startTime %@", startTime);
    
    
    
    // if it's yesterday, today or tomorrow use the word

    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *tomorrowExactly = [[NSDate alloc]
                        initWithTimeIntervalSinceNow:secondsPerDay];
    NSDate *yesterdayExactly = [[NSDate alloc]
                         initWithTimeIntervalSinceNow:-secondsPerDay];
   
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    // prepare yesterday for comparison
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:yesterdayExactly];
    NSDate *yesterday = [cal dateFromComponents:components];
    
    // prepare today for comparison
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    // prepare today for comparison
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:tomorrowExactly];
    NSDate *tomorrow = [cal dateFromComponents:components];
    
    
    
    // prepare other date for comparison
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:startTime];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([yesterday isEqualToDate:otherDate]) {
        NSLog(@"Yesterday");

    }else if([today isEqualToDate:otherDate]) {
        NSLog(@"Today");

    } else if([tomorrow isEqualToDate:otherDate]) {
        NSLog(@"Tomorrow");

    } else {
        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
        NSString *friendlyStartTime = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:startTime]];
        
        NSLog(@"FormattedDate: %@", friendlyStartTime);
    }
    
    
    
    XCTAssert(YES, @"Pass");
}



-(void)testCPDParsing {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ClientPageData" ofType:@"json"];
    NSData *clientPageDataJson = [NSData dataWithContentsOfFile:filePath];
    
    NSArray *pages = [CPDAPIClient includedPagesFromJSON:(NSDictionary *)clientPageDataJson error:nil];
    
    XCTAssertEqual(307, (unsigned long)pages.count, "Wrong number of pages parsed");
}

@end
