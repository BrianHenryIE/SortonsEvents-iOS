//
//  CPDAPIClient.m
//  Belfield
//
//  Created by Brian Henry on 20/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import "CPDAPIClient.h"
#import "IncludedPage.h"

NSString * const cpdBaseURL = @"https://sortonsevents.appspot.com/_ah/api/clientdata/v1/clientpagedata/";
// 197528567092983

@implementation CPDAPIClient


+ (CPDAPIClient *)sharedClient {
    static CPDAPIClient *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:cpdBaseURL]];
    });
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    return self;
}

- (void)getClientPages:(NSString *)cpid
               success:(void (^)(NSURLSessionDataTask *, id))success
               failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    
    NSString* path = [NSString stringWithFormat:@"%@", cpid];

    
    [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}



+ (NSArray *)includedPagesFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
//    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
//    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *includedPages = [[NSMutableArray alloc] init];
    
    NSArray *results = [objectNotation valueForKey:@"includedPages"];
    NSLog(@"Count %lu", (unsigned long)results.count);
    
    
    // For each object in the array of resutls
    for (NSDictionary *includedPagesDic in results) {
        
        // Prepare object
        IncludedPage *page = [[IncludedPage alloc] initWithDictionary:includedPagesDic];
      
        [includedPages addObject:page];
        
    }
    
    return includedPages;
}


@end
