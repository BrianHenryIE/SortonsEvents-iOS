//
//  CPDAPIClient.h
//  Belfield
//
//  Created by Brian Henry on 20/04/2015.
//  Copyright (c) 2015 Sortons. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

extern NSString * const cpdBaseURL;


@interface CPDAPIClient : AFHTTPSessionManager

+ (CPDAPIClient *)sharedClient;
+ (NSArray *)includedPagesFromJSON:(NSDictionary *)objectNotation error:(NSError **)error;

- (NSArray *)includedPagesFromCache;

- (void)getClientPages:(NSString *)cpid
                success:(void(^)(NSURLSessionDataTask *task, id responseObject))success
                failure:(void(^)(NSURLSessionDataTask *task, NSError *error))failure;

- (void)saveToCache:(NSData *)objectNotation;

@end
