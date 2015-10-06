//
//  DirectoryViewController.m
//  Belfield
//
//  Created by Brian Henry on 20/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import "DirectoryViewController.h"
#import "CPDAPIClient.h"
#import "SourcePage.h"
#import "IncludedPageCell.h"
#import "CommonWebViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Fomo.h"

@interface DirectoryViewController ()

@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSMutableArray *filteredData;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DirectoryViewController


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IncludedPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"includedPageCell" forIndexPath:indexPath];
    
    cell.cellTitle.text = ((SourcePage *) self.filteredData[indexPath.row]).name;

    cell.detailsLabel.text = @"";
    
    NSString *imageURLString = [NSString stringWithFormat: @"https://graph.facebook.com/%@/picture?type=large", ((SourcePage *) self.filteredData[indexPath.row]).pageId];
    [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:imageURLString]    placeholderImage:nil];
    //    [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:@"https://graph.facebook.com/olivier.poitrey/picture"]
    //                 placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]
    //                          options:SDWebImageRefreshCached]; // caches less aggressively

    cell.cellImage.layer.cornerRadius = cell.cellImage.frame.size.width / 2;
    cell.cellImage.clipsToBounds = YES;
    
    // Fix for multiline titles not laying out properly
    [cell layoutIfNeeded];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    SourcePage *selectedPage = _filteredData[indexPath.row];
    
    // Get user preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL runNative = [defaults boolForKey:@"launch_native_apps_toggle"];
   
    NSString *httpURLString = [NSString stringWithFormat: @"https://facebook.com/%@/", selectedPage.pageId];
    
    if(runNative==TRUE){
        NSString *appURLString = [NSString stringWithFormat: @"fb://profile/%@/", selectedPage.pageId];
        
        NSURL *facebookURL = [NSURL URLWithString:appURLString];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        } else {
            [self openInWebView:[NSURL URLWithString:httpURLString]];
        }
    } else {
        [self openInWebView:[NSURL URLWithString:httpURLString]];
    }
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



// duplicate code! (also in EventsViewController)
-(void)openInWebView:(NSURL*)url{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"CommonWebViewController"];

    CommonWebViewController *cwvs = [CommonWebViewController alloc];
    cwvs = (CommonWebViewController *) myController;
    
    [cwvs setWebViewURL:url];
    
    self.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentViewController:myController animated:YES completion:NULL];

}


// Filter the list when searching
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    
    if(searchText.length==0){
        _filteredData = [NSMutableArray arrayWithArray:_dataSource];
    }else {
        [self.filteredData removeAllObjects];
        for (SourcePage *item in self.dataSource)
        {
            // drop the case for search
            if([item.name.lowercaseString containsString:searchText.lowercaseString]){
                [self.filteredData addObject:item];
            }
        }
    }
    
    [self.tableView reloadData];
    
}


// Hide the keybaord
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    // probably goes somewhere else
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}



#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CPDAPIClient *client = [CPDAPIClient sharedClient];
    
    _dataSource = [client includedPagesFromCache];
    _filteredData = [NSMutableArray arrayWithArray:_dataSource];
    [self.tableView reloadData];
    
    [client getClientPages:[Fomo fomoId]
                   success:^(NSURLSessionDataTask *task, id responseObject) {
                       _dataSource = [CPDAPIClient includedPagesFromJSON:(NSDictionary *)responseObject error:nil];
                       _filteredData = [NSMutableArray arrayWithArray:_dataSource];
                       [self.tableView reloadData];
                   }
                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                       NSLog(@"Failure -- %@", error);
                   }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
