//
//  EventsViewController.m
//  DublinTheatreOC
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//

#import "EventsViewController.h"

#import "DiscoveredEvent.h"
#import "SortonsEventsManager.h"
#import "SortonsEventsCommunicator.h"
#import "DiscoveredEventCell.h"

#import "AsyncImageView.h"

@interface EventsViewController () <SortonsEventsManagerDelegate> {
    NSArray *_discoveredEvents;
    SortonsEventsManager *_manager;
}

@end

@implementation EventsViewController
{
    NSArray *tableData;
    IBOutlet UITableView *tableViewOutlet;
}


- (void)startFetchingDiscoveredEvents
{
    [_manager fetchDiscoveredEvents];
}

- (NSString *)friendlyDate:(NSString *)deDateString
{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSDate *startTime = [dateFormat dateFromString:deDateString];
  
    
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
    
    [dateFormat setDateFormat:@"HH:mm"];

    if([yesterday isEqualToDate:otherDate]) {
        NSString *friendlyStartTime = [NSString stringWithFormat:@"Yesterday at %@",[dateFormat stringFromDate:startTime]];
        return friendlyStartTime;
        
    }else if([today isEqualToDate:otherDate]) {
        NSString *friendlyStartTime = [NSString stringWithFormat:@"Today at %@",[dateFormat stringFromDate:startTime]];
        return friendlyStartTime;
        
    } else if([tomorrow isEqualToDate:otherDate]) {
        NSString *friendlyStartTime = [NSString stringWithFormat:@"Tomorrow at %@",[dateFormat stringFromDate:startTime]];
        return friendlyStartTime;
        
    } else {

//        [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
        [dateFormat setDateFormat:@"EEEE dd MMM 'at' HH:mm"];
        NSString *friendlyStartTime = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:startTime]];
        
        return friendlyStartTime;
    }
    
    
}

- (void)didReceiveDiscoveredEvents:(NSArray *)discoveredEvents
{
    NSLog(@"ViewController didReceiveDiscoveredEvents");
    _discoveredEvents = discoveredEvents;
    tableData = discoveredEvents;
    
    // [self.tableView reloadData];
    [tableViewOutlet performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (void)fetchingDiscoveredEventsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _discoveredEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DiscoveredEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discoveredEventCell" forIndexPath:indexPath];
    
    // Clear old images asap when cells are being reused.
    cell.theImage.image = nil;
    
    DiscoveredEvent *discoveredEvent = _discoveredEvents[indexPath.row];
    [cell.nameLabel setText:discoveredEvent.name];
 
    // [cell.startTimeLabel setText:discoveredEvent.startTime];
    NSString *friendlyDate = [self friendlyDate:discoveredEvent.startTime];
    [cell.startTimeLabel setText:friendlyDate];
    
    [cell.locationLabel setText:discoveredEvent.location];
    
    // Download the images once only!

    NSString *imageURLString = [NSString stringWithFormat: @"http://graph.facebook.com/%@/picture?type=square", discoveredEvent.eid];
    NSURL *imageURL = [NSURL URLWithString:imageURLString];

    cell.theImage.imageURL = imageURL;
    
    return cell;    
}

#pragma mark - UITableViewDelegate

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    DiscoveredEvent *discoveredEvent = _discoveredEvents[indexPath.row];

    NSString *eventAppURLString = [NSString stringWithFormat: @"fb://profile/%@/", discoveredEvent.eid];
    NSString *eventHttpURLString = [NSString stringWithFormat: @"http://facebook.com/events/%@/", discoveredEvent.eid];
    
    NSURL *facebookURL = [NSURL URLWithString:eventAppURLString];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:eventHttpURLString]];
    }
    
    
    //NSURL *url = [NSURL URLWithString:eventAppURLString];
    //[[UIApplication sharedApplication] openURL:url];
    
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _manager = [[SortonsEventsManager alloc] init];
    _manager.communicator = [[SortonsEventsCommunicator alloc] init];
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
    
    tableViewOutlet.estimatedRowHeight = 300;
    tableViewOutlet.rowHeight = UITableViewAutomaticDimension;
    
    [self startFetchingDiscoveredEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
