//
//  NewsViewController.m
//  Belfield
//
//  Created by Brian Henry on 13/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import "NewsViewController.h"
#import "CommonWebViewController.h"

@interface NewsViewController () <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //load url into webview

    // The correct URL... TODO, build it properly from a plist
    NSString *strURL = @"http://sortonsevents.appspot.com/recentpostsmobile/news.html#197528567092983";
    
    
    //NSString *strURL = @"http://172.20.10.2/~brianhenry/SortonsEvents-Gwt-AppEngine-Java/src/main/webapp/recentpostsmobile/news.html#197528567092983";
    
    NSURL *url = [NSURL URLWithString:strURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    // When the view is preloaded, the content is loaded at the wrong width, so I'm hiding the view until I've told it to refresh (and it will at least be cached)
    self.webView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

    // Get the URL clicked and display it in a modal webview.
    // Maybe the webview should be a singleton?!
    if (navigationType == UIWebViewNavigationTypeLinkClicked){

        NSURL *url = [request URL];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"CommonWebViewController"];

        CommonWebViewController *cwvs = [CommonWebViewController alloc];
        cwvs = (CommonWebViewController *) myController;
        
        [cwvs setWebViewURL:url];
        
        self.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
        [self presentViewController:myController animated:YES completion:NULL];
        
        return NO;
    }
    
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // TODO
    // Check was the view already rendered in this same orientation => don't rerender
    
    [self.webView stringByEvaluatingJavaScriptFromString:@"refreshXfbml()"];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(showWebView)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)showWebView
{
    self.webView.hidden = NO;
}


// Redraw the news items after the phone rotates
// because they're the wrong width now.
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (self.view.superview){

    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    // Hide the view so the ill sized news items don't rotate
    self.webView.hidden = YES;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        self.webView.hidden = NO;
        
                    // Do view manipulation here.
            [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
            
            //        [self.webView stringByEvaluatingJavaScriptFromString:@"stopJS()"];
            [self.webView stringByEvaluatingJavaScriptFromString:@"refreshXfbml()"];
            
            NSLog(@"view rotated");
        
    }];
    }
    
    
}


@end
