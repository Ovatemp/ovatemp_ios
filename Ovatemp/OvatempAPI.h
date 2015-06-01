//
//  OvatempAPI.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "Stripe.h"

#import "ILDay.h"
#import "ILCycle.h"
#import "ILPaginationInfo.h"

typedef void (^ErrorCompletionBlock)(NSError *error);
typedef void (^CompletionBlock)(id object, NSError *error);
typedef void (^PaginatedCompletionBlock)(id object, ILPaginationInfo *pagination, NSError *error);

@interface OvatempAPI : AFHTTPSessionManager

+ (id)sharedSession;

- (void)resetAccessToken;

// Days

- (void)getDaysOnPage:(NSUInteger)page perPage:(NSInteger)perPage completion:(PaginatedCompletionBlock)completion;
- (void)getDayWithId:(NSNumber *)dayId completion:(CompletionBlock)completion;
- (void)updateDay:(ILDay *)day withParameters:(NSDictionary *)parameters completion:(CompletionBlock)completion;

// Cycles

- (void)getCyclesOnPage:(NSUInteger)page completion:(PaginatedCompletionBlock)completion;

// Supplements, Medicines

- (void)createSupplement:(NSString *)supplementName completion:(CompletionBlock)completion;
- (void)deleteSupplementWithId:(NSNumber *)supplementId completion:(ErrorCompletionBlock)completion;

- (void)createMedicine:(NSString *)medicineName completion:(CompletionBlock)completion;
- (void)deleteMedicineWithId:(NSNumber *)medicineId completion:(ErrorCompletionBlock)completion;

// Stripe, Apple Pay

- (void)createBackendChargeWithToken:(STPToken *)token payment:(PKPayment *)payment amount:(NSDecimalNumber *)amount
                          completion:(CompletionBlock)completion;

@end
