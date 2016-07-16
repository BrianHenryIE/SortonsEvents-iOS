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
#import <SDWebImage/UIImageView+WebCache.h>
#import "CommonWebViewController.h"
#import "DiscoveredEventBuilder.h"

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



- (NSString *)friendlyDate:(DiscoveredEvent *)discoveredEvent
{
    NSDate *dateTime = discoveredEvent.startTime;
 

    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
   // [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    
    // if it's yesterday, today or tomorrow use the word
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *tomorrowExactly = [[NSDate alloc]
                               initWithTimeIntervalSinceNow:secondsPerDay];
    NSDate *yesterdayExactly = [[NSDate alloc]
                                initWithTimeIntervalSinceNow:-secondsPerDay];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
//    [cal setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Dublin"]];
    
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
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:dateTime];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    [dateFormat setDateFormat:@"HH:mm"];

    if([yesterday isEqualToDate:otherDate]) {
        NSString *friendlyTime = [NSString stringWithFormat:@"Yesterday at %@",[dateFormat stringFromDate:dateTime]];
        return friendlyTime;
        
    }else if([today isEqualToDate:otherDate]) {
        NSString *friendlyTime = [NSString stringWithFormat:@"Today at %@",[dateFormat stringFromDate:dateTime]];
        return friendlyTime;
        
    } else if([tomorrow isEqualToDate:otherDate]) {
        NSString *friendlyTime = [NSString stringWithFormat:@"Tomorrow at %@",[dateFormat stringFromDate:dateTime]];
        return friendlyTime;
        
    } else {

        if(discoveredEvent.isDateOnly){
            [dateFormat setDateFormat:@"EEEE dd MMM"];
        }else{
            [dateFormat setDateFormat:@"EEEE dd MMM 'at' HH:mm"];
        }
        NSString *friendlyTime = [dateFormat stringFromDate:dateTime];
        
        return friendlyTime;
    }
    
    
}

- (void)didReceiveDiscoveredEvents:(NSArray *)discoveredEvents
{
    // NSLog(@"ViewController didReceiveDiscoveredEvents");
    _discoveredEvents = discoveredEvents;
    tableData = discoveredEvents;
    
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
    
    DiscoveredEvent *discoveredEvent = _discoveredEvents[indexPath.row];
    
    [cell.nameLabel setText:discoveredEvent.name];
    
    // Format and set date
    NSString *friendlyDate = [self friendlyDate:discoveredEvent];
    [cell.startTimeLabel setText:friendlyDate];
    
    [cell.locationLabel setText:discoveredEvent.location];
   
    // Set image
    NSString *imageURLString = [NSString stringWithFormat: @"https://graph.facebook.com/%@/picture?type=square", discoveredEvent.eventId];
    [cell.theImage sd_setImageWithURL:[NSURL URLWithString:imageURLString]];
    // Round corners of image
    cell.theImage.layer.cornerRadius = cell.theImage.frame.size.width / 2;
    cell.theImage.clipsToBounds = YES;

    // Fix for multiline titles not laying out properly
    [cell layoutIfNeeded];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    DiscoveredEvent *discoveredEvent = _discoveredEvents[indexPath.row];
    
    // Get user preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL runNative = [defaults boolForKey:@"launch_native_apps_toggle"];
    
    NSString *eventHttpURLString = [NSString stringWithFormat: @"https://facebook.com/events/%@/", discoveredEvent.eventId];
    
    if(runNative==TRUE){
        NSLog(@"Run native");
        NSString *eventAppURLString = [NSString stringWithFormat: @"fb://profile/%@/", discoveredEvent.eventId];
    
        NSURL *facebookURL = [NSURL URLWithString:eventAppURLString];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        } else {
            [self openInWebView:[NSURL URLWithString:eventHttpURLString]];
        }
    } else {
        [self openInWebView:[NSURL URLWithString:eventHttpURLString]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)openInWebView:(NSURL*)url{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"CommonWebViewController"];
    
    CommonWebViewController *cwvs = [CommonWebViewController alloc];
    cwvs = (CommonWebViewController *) myController;
    
    [cwvs setWebViewURL:url];
    
    self.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:myController animated:YES completion:NULL];
    
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO: test this code!
    
    // Read from cache
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesFolder = paths[0];
    NSString *fullPath = [cachesFolder stringByAppendingPathComponent:@"eventscache.txt"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:fullPath]){
        // NSLog(@"reading from cache");
        NSData *cache = [NSData dataWithContentsOfFile:fullPath];
        NSMutableArray *discoveredEvents = [NSMutableArray arrayWithArray:[DiscoveredEventBuilder discoveredEventsFromJSON:cache error:nil]];
        
        DiscoveredEvent *item;
        NSMutableArray *itemsToKeep = [NSMutableArray arrayWithCapacity:[discoveredEvents count]];
        
        NSDate *now = [[NSDate alloc] init];
        for (item in discoveredEvents) {
            if (!(item.startTime < now))
                [itemsToKeep addObject:item];
        }
        [discoveredEvents setArray:itemsToKeep];
        
        _discoveredEvents = discoveredEvents;
        [tableViewOutlet reloadData];
    }
    
    
    // Preload the subsquent tabs
    for (UIViewController *aVC in self.tabBarController.viewControllers)
        if ([aVC respondsToSelector:@selector(view)] && aVC != self)
            [aVC view];
    
    
    _manager = [[SortonsEventsManager alloc] init];
    _manager.communicator = [[SortonsEventsCommunicator alloc] init];
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
    
    tableViewOutlet.rowHeight = UITableViewAutomaticDimension;
    tableViewOutlet.estimatedRowHeight = 300;
    
    [self startFetchingDiscoveredEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end