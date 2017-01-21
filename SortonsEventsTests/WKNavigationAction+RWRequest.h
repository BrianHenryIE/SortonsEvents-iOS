#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

// Extension to allow write read only properties

@interface WKNavigationAction ()

@property (nonatomic, readwrite) NSURLRequest *request;

@property WKNavigationType navigationType;

@property BOOL testBool;

@end
