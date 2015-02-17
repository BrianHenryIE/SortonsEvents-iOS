//
//  ViewController.m
//  DublinTheatreOC
//
//  Created by Brian Henry on 15/02/2015.
//  Copyright (c) 2015 Sorton. All rights reserved.
//

#import "ViewController.h"

#import "DiscoveredEvent.h"
#import "SortonsEventsManager.h"
#import "SortonsEventsCommunicator.h"
#import "DetailCell.h"

#import "AsyncImageView.h"

@interface ViewController () <SortonsEventsManagerDelegate> {
    NSArray *_discoveredEvents;
    NSMutableArray *_downloadedImages;
    SortonsEventsManager *_manager;
}
@end

@implementation ViewController


- (void)startFetchingDiscoveredEvents
{
    [_manager fetchDiscoveredEvents];
}

- (void)didReceiveDiscoveredEvents:(NSArray *)discoveredEvents
{
    NSLog(@"ViewController didReceiveDiscoveredEvents");
    _discoveredEvents = discoveredEvents;
    [self.tableView reloadData];
}

- (void)fetchingDiscoveredEventsFailedWithError:(NSError *)error
{
    NSLog(@"Error %@; %@", error, [error localizedDescription]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _discoveredEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discoveredEventCell" forIndexPath:indexPath];
    
    DiscoveredEvent *discoveredEvent = _discoveredEvents[indexPath.row];
    [cell.nameLabel setText:discoveredEvent.name];
    
    // 2015-02-16T00:00:00.000Z
    
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"EEE, MM-dd-yyyy"];
//    NSDate *dt = [NSDate date];
//    NSString *dateAsString = [formatter stringFromDate:dt];
//    [formatter release];

//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
//    NSDate *startTime = [dateFormat dateFromString:discoveredEvent.startTime];
//    
//    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm"];
//    NSString *friendlyStartTime = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:startTime]];
//    
//    [cell.startTimeLabel setText:friendlyStartTime];
   
    [cell.startTimeLabel setText:discoveredEvent.startTime];
    
    [cell.locationLabel setText:discoveredEvent.location];
    
    // Download the images once only!
//    if(_downloadedImages.count < indexPath.row){
//        NSLog(@"Image on row %ld not found, downloading.", (long)indexPath.row);

        NSString *imageURLString = [NSString stringWithFormat: @"http://graph.facebook.com/%@/picture?type=square", discoveredEvent.eid];
        NSURL *imageURL = [NSURL URLWithString:imageURLString];
//        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//        // Store the data
//        UIImage *image = [UIImage imageWithData:imageData];
//        
//        // This isn't working
//        [_downloadedImages addObject:image];
//        
//        cell.theImage.image = image;
//    } else {
//        NSLog(@"Using cached image for row %ld.", (long)indexPath.row);

//        cell.theImage.image = _downloadedImages[indexPath.row];
//    }

    cell.theImage.imageURL = imageURL;
    
    return cell;    
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

    DiscoveredEvent *discoveredEvent = _discoveredEvents[indexPath.row];

     NSString *eventURLString = [NSString stringWithFormat: @"fb://profile/%@/", discoveredEvent.eid];
    NSURL *url = [NSURL URLWithString:eventURLString];
    [[UIApplication sharedApplication] openURL:url];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _manager = [[SortonsEventsManager alloc] init];
    _manager.communicator = [[SortonsEventsCommunicator alloc] init];
    _manager.communicator.delegate = _manager;
    _manager.delegate = self;
   
    [self startFetchingDiscoveredEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
