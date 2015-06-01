//
//  OvatempAPI.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "OvatempAPI.h"

#import "NSArray+ArrayMap.h"
#import "PaymentHelper.h"

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
        NSString *baseUrlString                            = [NSString stringWithFormat: @"%@/api", ROOT_URL];
        NSURL *baseUrl                                     = [NSURL URLWithString: baseUrlString];
        
        _instance                                          = [[OvatempAPI alloc] initWithBaseURL: baseUrl sessionConfiguration: urlSessionConfiguration];
        _instance.requestSerializer                        = [AFJSONRequestSerializer serializer];
        [_instance.requestSerializer setValue: @"application/vnd.ovatemp.v3" forHTTPHeaderField: @"Accept"];
        [_instance.requestSerializer setValue: [self accessToken] forHTTPHeaderField: @"Authorization"];
        _instance.responseSerializer                       = [AFJSONResponseSerializer serializer];
        
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

- (NSString *)accessToken
{
    return [Configuration sharedConfiguration].token;
}

- (void)resetAccessToken
{
    [self.requestSerializer setValue: [self accessToken] forHTTPHeaderField: @"Authorization"];
}

#pragma mark - REST Methods
#pragma mark - Days

- (void)getDayWithId:(NSNumber *)dayId completion:(CompletionBlock)completion
{
    NSString *url = [NSString stringWithFormat: @"days/%@", dayId];
    
    [self GET: url parameters: nil success:^(NSURLSessionDataTask *task, id responseObject) {
        ILDay *day = [[ILDay alloc] initWithDictionary: responseObject[@"day"]];
        completion(day, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    
}

- (void)updateDay:(ILDay *)day withParameters:(NSDictionary *)parameters completion:(CompletionBlock)completion
{
    NSDictionary *params = @{@"day" : parameters};
    
    if (parameters[@"symptom_ids"]) {
        NSMutableArray *symptomIds = parameters[@"symptom_ids"];
        if ([symptomIds count] == 0) {
            [symptomIds addObject: @(0)];
        }
    }else if (parameters[@"medicine_ids"]) {
        NSMutableArray *medicineIds = parameters[@"medicine_ids"];
        if ([medicineIds count] == 0) {
            [medicineIds addObject: @(0)];
        }
    }else if (parameters[@"supplement_ids"]) {
        NSMutableArray *supplementIds = parameters[@"supplement_ids"];
        if ([supplementIds count] == 0) {
            [supplementIds addObject: @(0)];
        }
    }
    
    [self PUT: @"days" parameters: params success:^(NSURLSessionDataTask *task, id responseObject) {
        ILDay *day = [[ILDay alloc] initWithDictionary: responseObject[@"day"]];
        completion(day, nil);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

- (void)getDaysOnPage:(NSUInteger)page perPage:(NSInteger)perPage completion:(PaginatedCompletionBlock)completion;
{
    NSString *url = @"days";
    NSInteger perPageDefault = (perPage != 0) ? perPage : 365;
    NSDictionary *params = @{@"page" : @(page),
                             @"per_page" : @(perPageDefault)};
    
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

#pragma mark - Supplements/Medicines

- (void)createSupplement:(NSString *)supplementName completion:(CompletionBlock)completion
{
    
}

- (void)deleteSupplementWithId:(NSNumber *)supplementId completion:(ErrorCompletionBlock)completion
{
    [self deleteObjectWithId: supplementId atURL: @"supplements" completion: completion];
}

- (void)createMedicine:(NSString *)medicineName completion:(CompletionBlock)completion
{
    
}

- (void)deleteMedicineWithId:(NSNumber *)medicineId completion:(ErrorCompletionBlock)completion
{
    [self deleteObjectWithId: medicineId atURL: @"medicines" completion: completion];
}

- (void)deleteObjectWithId:(NSNumber *)objectId atURL:(NSString *)deleteURL completion:(ErrorCompletionBlock)completion
{
    NSString *url = [NSString stringWithFormat: @"%@/%@", deleteURL, objectId];
    
    [self DELETE: url parameters: nil success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(error);
    }];
}

#pragma mark - Apple Pay

- (void)createBackendChargeWithToken:(STPToken *)token payment:(PKPayment *)payment amount:(NSDecimalNumber *)amount completion:(CompletionBlock)completion
{
    NSString *url = @"transactions";

    NSString *fullName        = [self fullNameForPayment: payment];
    NSString *shippingAddress = [self shippingAddressForPayment: payment];
    NSString *email           = [self emailForPayment: payment];
    NSString *phone           = [self phoneForPayment: payment];
    
    NSDecimalNumber *amountInCents = [amount decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString: @"100"]];
    
    NSDictionary *params = @{@"transaction" : @{@"stripeToken" : token.tokenId,
                                                @"amount" : amountInCents,
                                                @"shipping_method" : payment.shippingMethod.label,
                                                @"shipping_address" : shippingAddress,
                                                @"shipping_contact" : @{@"email" : email,
                                                                        @"phone" : phone,
                                                                        @"name" : fullName}
                                                }};
    
    DDLogInfo(@"PARAMS: %@", params);

    [self POST: url parameters: params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
    
}

#pragma mark - Helper's

- (NSString *)emailForPayment:(PKPayment *)payment
{
    return [PaymentHelper emailForPayment: payment];
}

- (NSString *)phoneForPayment:(PKPayment *)payment
{
    return [PaymentHelper phoneForPayment: payment];
}

- (NSString *)fullNameForPayment:(PKPayment *)payment
{
    return [PaymentHelper fullNameForPayment: payment];
}

- (NSString *)shippingAddressForPayment:(PKPayment *)payment
{
    return [PaymentHelper shippingAddressForPayment: payment];
}

@end
