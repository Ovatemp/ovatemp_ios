//
//  OvatempAPI.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "ILDay.h"
#import "ILCycle.h"
#import "ILPaginationInfo.h"

typedef void (^CompletionBlock)(id object, NSError *error);
typedef void (^PaginatedCompletionBlock)(id object, ILPaginationInfo *pagination, NSError *error);

@interface OvatempAPI : AFHTTPSessionManager

+ (id)sharedSession;

- (void)getDaysOnPage:(NSUInteger)page perPage:(NSInteger)perPage completion:(PaginatedCompletionBlock)completion;

- (void)getDayWithId:(NSNumber *)dayId completion:(CompletionBlock)completion;
- (void)updateDay:(ILDay *)day withParameters:(NSDictionary *)parameters completion:(CompletionBlock)completion;

- (void)getCyclesOnPage:(NSUInteger)page completion:(PaginatedCompletionBlock)completion;

@end
