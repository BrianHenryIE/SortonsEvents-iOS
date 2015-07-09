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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CommonWebViewController.h"

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
    
    // If we're logged into Facebook, go get the friends that are attending
    if ([FBSDKAccessToken currentAccessToken]) {
        NSLog(@"Logged in to Facebook (Events View)");
        /* make the API call */
        NSLog(@"%@", [FBSDKAccessToken currentAccessToken]);
        
    }else{
        NSLog(@"NOT Logged in to Facebook (Events View)");
    }
    
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
    NSString *friendlyDate = [self friendlyDate:discoveredEvent.startTime];
    [cell.startTimeLabel setText:friendlyDate];
    
    [cell.locationLabel setText:discoveredEvent.location];
   
    // Set image
    NSString *imageURLString = [NSString stringWithFormat: @"http://graph.facebook.com/%@/picture?type=square", discoveredEvent.eid];
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
    
    NSString *eventHttpURLString = [NSString stringWithFormat: @"http://facebook.com/events/%@/", discoveredEvent.eid];
    
    if(runNative==TRUE){
        NSLog(@"Run native");
        NSString *eventAppURLString = [NSString stringWithFormat: @"fb://profile/%@/", discoveredEvent.eid];
    
        NSURL *facebookURL = [NSURL URLWithString:eventAppURLString];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        } else {
            [self openInWebView:[NSURL URLWithString:eventHttpURLString]];
        }
    } else {
        [self openInWebView:[NSURL URLWithString:eventHttpURLString]];
    }
    
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
