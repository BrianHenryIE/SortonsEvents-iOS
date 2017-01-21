//
//  WKNavigationActionMock.h
//  SortonsEvents
//
//  Created by Brian Henry on 17/01/2017.
//  Copyright © 2017 Sortons. All rights reserved.
//

#import "WKNavigationActionMock.h"

@implementation WKNavigationActionMock 
    
- (id)init {
    self = [super init];
 
    _request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString:@"http://www.sortons.ie"]];
    
    return self;
}
    
@end
