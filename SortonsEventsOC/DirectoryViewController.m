//
//  DirectoryViewController.m
//  Belfield
//
//  Created by Brian Henry on 20/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import "DirectoryViewController.h"
#import "CPDAPIClient.h"
#import "DirectoryCollectionViewCell.h"
#import "IncludedPage.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CommonWebViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DirectoryViewController ()

@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) NSMutableArray *filteredData;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property int boxSize;


@end

@implementation DirectoryViewController

static NSString * const reuseIdentifier = @"pagecollectioncell";


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CPDAPIClient *client = [CPDAPIClient sharedClient];
    
    [client getClientPages:@"197528567092983"
                    success:^(NSURLSessionDataTask *task, id responseObject) {
                        _dataSource = [CPDAPIClient includedPagesFromJSON:(NSData *)responseObject error:nil];
                        _filteredData = [NSMutableArray arrayWithArray:_dataSource];
                        [self.collectionView reloadData];
                    }
                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                        NSLog(@"Failure -- %@", error);
                    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [self calculateBestBoxSize:width];
    
    // this line probably isnt needed
    [flowLayout setItemSize:CGSizeMake(self.boxSize, self.boxSize)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // Maybe later this will be two... one for active pages and one for dormant ones
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DirectoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
 
    cell.cellTitle.text = ((IncludedPage *) self.filteredData[indexPath.row]).name;

    // This can probably be somewhere more efficient.
    cell.cellTitle.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    cell.cellTitle.layer.shadowRadius = 5.0;
    cell.cellTitle.layer.shadowOpacity = 1.0;
    
    
    NSString *imageURLString = [NSString stringWithFormat: @"http://graph.facebook.com/%@/picture?type=large", ((IncludedPage *) self.filteredData[indexPath.row]).pageId];
    [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:imageURLString]    placeholderImage:nil];
//    [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:@"https://graph.facebook.com/olivier.poitrey/picture"]
//                 placeholderImage:[UIImage imageNamed:@"avatar-placeholder.png"]
//                          options:SDWebImageRefreshCached]; // caches less aggressively

    
    // Move this to ViewDidLoad?
    if ([FBSDKAccessToken currentAccessToken]) {
        // NSLog(@"Logged in to Facebook (Directory View)");
    }else{
        // NSLog(@"NOT Logged in to Facebook (Directory View)");
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    IncludedPage *selectedPage = _filteredData[indexPath.row];
    
    // Get user preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL runNative = [defaults boolForKey:@"launch_native_apps_toggle"];
    
    NSString *httpURLString = [NSString stringWithFormat: @"http://facebook.com/%@/", selectedPage.pageId];
    
    if(runNative==TRUE){
        NSLog(@"Run native");
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // Do view manipulation here.
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self calculateBestBoxSize:size.width];
    [self.collectionView.collectionViewLayout invalidateLayout];

}

-(void)calculateBestBoxSize:(int)width{
    
    NSLog(@"width: %d", width);
    
    // around 165 is nice.
    // I was going to run a calculation here to find the best
    // width but instead I'm running a switch
    
    switch ((int)width)
    {
        case 320: //iPhone 4S, 5 portrait
            self.boxSize = 155;
            break;
        case 375: // iPhone 6, portrait
            self.boxSize = 182;
            break;
        case 768: // iPad 2, mini, air, portrait
            self.boxSize = 184;
            break;
        case 480: // iPhone 4s, landscape
            self.boxSize = 153;
            break;
        case 1024: // iPad 2, landscape
            self.boxSize = 196;
            break;
        case 414: // iPhone 6+, portrait
            self.boxSize = 131;
            break;
        case 568: // iPhone 5, landscape
            self.boxSize = 182;
            break;
        case 667:  // iPhone 6, landscape
            self.boxSize = 159;
            break;
        case 736: // iPhone 6+ landscape
            self.boxSize = 176;
            break;
            
        default: // future models!
            self.boxSize = 165;
            break;
            
    }
    

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.boxSize, self.boxSize);
}

// Filter the list when searching
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    
    if(searchText.length==0){
        _filteredData = [NSMutableArray arrayWithArray:_dataSource];
    }else {
        [self.filteredData removeAllObjects];
        for (IncludedPage *item in self.dataSource)
        {
            // drop the case for search
            if([item.name.lowercaseString containsString:searchText.lowercaseString]){
                [self.filteredData addObject:item];
            }
        }
    }
    [self.collectionView reloadData];
    
}

// Hide the keybaord
- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    // probably goes somewhere else
    scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}


@end
