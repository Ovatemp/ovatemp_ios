//
//  OvatempAPI.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "OvatempAPI.h"

#import "NSArray+ArrayMap.h"

#import "ILDay.h"
#import "ILCycle.h"

@implementation OvatempAPI

#pragma mark - Singleton Initialization

+ (id)sharedSession
{
    static OvatempAPI *_instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *urlSessionConfiguration = [self sessionConfiguration];
        NSURL *baseUrl = [NSURL URLWithString: ROOT_URL];
        _instance = [[OvatempAPI alloc] initWithBaseURL: baseUrl sessionConfiguration: urlSessionConfiguration];
        [_instance.requestSerializer setValue: @"application/vnd.ovatemp.v3" forHTTPHeaderField: @"Accept"];
        [_instance.requestSerializer setValue: [self accessToken] forHTTPHeaderField: @"Authorization"];
        
    });
    
    return _instance;
}

+ (NSURLSessionConfiguration *)sessionConfiguration
{
    NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    // Further session configuration
    return urlSessionConfiguration;
}

+ (NSString *)accessToken
{
    return [Configuration sharedConfiguration].token;
}

#pragma mark - REST Methods
#pragma mark - Days

- (void)getDayWithId:(NSUInteger)dayId completion:(CompletionBlock)completion
{
    NSString *url = [NSString stringWithFormat: @"days/%lu", (unsigned long)dayId];
    
    [self GET: url parameters: nil success:^(NSURLSessionDataTask *task, id responseObject) {
        ILDay *day = [[ILDay alloc] initWithDictionary: responseObject[@"day"]];
        completion(day, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    
}

- (void)getDaysOnPage:(NSUInteger)page completion:(PaginatedCompletionBlock)completion
{
    NSString *url = @"days";
    NSDictionary *params = @{@"page" : @(page),
                             @"per_page" : @(60)};
    
    [self GET: url parameters: params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *days = [responseObject[@"days"] dl_map:^ ILDay *(NSDictionary *day) {
            return [[ILDay alloc] initWithDictionary: day];
        }];
        
        ILPaginationInfo *pagination = [[ILPaginationInfo alloc] initWithDictionary: responseObject[@"meta"][@"pagination"]];
        completion(days, pagination, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, nil, error);
    }];
}

#pragma mark - Cycles

- (void)getCyclesOnPage:(NSUInteger)page completion:(PaginatedCompletionBlock)completion
{
    NSString *url = @"cycles";
    NSDictionary *params = @{@"page" : @(page),
                             @"per_page" : @(3)};
    
    [self GET: url parameters: params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *cycles = [responseObject[@"cycles"] dl_map:^ ILCycle *(NSDictionary *cycle) {
            return [[ILCycle alloc] initWithDictionary: cycle];
        }];
        
        ILPaginationInfo *pagination = [[ILPaginationInfo alloc] initWithDictionary: responseObject[@"meta"][@"pagination"]];
        completion(cycles, pagination, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion (nil, nil, error);
    }];
}

@end
