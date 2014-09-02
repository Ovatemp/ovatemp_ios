//
//  SubscriptionHelper.m
//  Ovatemp
//
//  Created by Ed Schmalzle on 6/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SubscriptionHelper.h"
#import <StoreKit/StoreKit.h>

NSString *const SubscriptionHelperProductPurchasedNotification = @"SubscriptionHelperProductPurchasedNotification";
NSString *const SubscriptionExpirationDefaultsKey = @"SubscriptionHelperProductPurchasedNotification";

@interface SubscriptionHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation SubscriptionHelper {
  SKProductsRequest *_productsRequest;
  RequestProductsCompletionHandler _completionHandler;
  NSSet *_productIdentifiers;
}

- (id) init {

  self = [super init];
  if(self) {
    _productIdentifiers = [[NSSet alloc] initWithArray:[[NSArray alloc] initWithObjects:
                                                        @"OneMonth",
                                                        @"ThreeMonths",
                                                        @"SixMonths", nil]];
    
  }
  
  [[SKPaymentQueue defaultQueue] addTransactionObserver: self];
  
  return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
  
  _completionHandler = [completionHandler copy];
  
  _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers: _productIdentifiers];
  _productsRequest.delegate = self;
  
  [_productsRequest start];
}

+ (SubscriptionHelper*) sharedInstance {

  static dispatch_once_t once;
  static SubscriptionHelper *sharedInstance;
  
  dispatch_once( &once, ^{
    sharedInstance = [[self alloc] init];
  });
  
  return sharedInstance;
}

- (void) restorePurchases {
  
  [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark - SKPaymentTransaction Observer

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
  
  for (SKPaymentTransaction *transaction in transactions) {
    switch (transaction.transactionState) {
      case SKPaymentTransactionStatePurchased:
        [self completeTransaction: transaction];
        break;
      case SKPaymentTransactionStateFailed:
        [self failedTransaction: transaction];
        break;
      case SKPaymentTransactionStateRestored:
        [self restoreTransaction: transaction];
      default:
        break;
    }
  };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
  
  [self provideContentForProductIdentifier: transaction.payment.productIdentifier
                               purchasedOn: transaction.transactionDate];
  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
  
  [self provideContentForProductIdentifier: transaction.originalTransaction.payment.productIdentifier
                               purchasedOn: transaction.originalTransaction.transactionDate];
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier: (NSString *) productIdentifier purchasedOn: (NSDate*) transactionDate {
  
  [self updateSubscriptionStatusForProductIdentifier: productIdentifier purchasedOn: transactionDate];
  [[NSNotificationCenter defaultCenter] postNotificationName:SubscriptionHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
  
  if (transaction.error.code != SKErrorPaymentCancelled) {
    NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
  }
  
  [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark - Subscription status/update helpers

- (void)updateSubscriptionStatusForProductIdentifier: (NSString*) productIdentifier purchasedOn: (NSDate*) transactionDate {
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDate *currentExpirationDate = [defaults objectForKey: SubscriptionExpirationDefaultsKey];
  
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [[NSDateComponents alloc] init];
  if([productIdentifier isEqualToString: @"OneMonth"]) {
    [components setMonth: 1];
  } else if([productIdentifier isEqualToString: @"ThreeMonths"]) {
    [components setMonth: 3];
  } else if([productIdentifier isEqualToString: @"SixMonths"]) {
    [components setMonth: 6];
  }
  NSDate *newExpirationDate = [calendar dateByAddingComponents: components toDate: transactionDate options: 0];
  
  NSLog(@"The new expiration date is: %@", [newExpirationDate classicDate]);
  
  if(!currentExpirationDate || [currentExpirationDate compare: newExpirationDate] == NSOrderedAscending) {
    [defaults setObject: newExpirationDate forKey: SubscriptionExpirationDefaultsKey];
    [defaults synchronize];
  }
}

- (BOOL) hasActiveSubscription {
  
  NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey: SubscriptionExpirationDefaultsKey];
  NSDate *today = [NSDate date];
  
  if(date && [today compare: date] == NSOrderedAscending) {
    return YES;
  }
  
  return NO;
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
  
  _productsRequest = nil;
  
  NSArray *skProducts = response.products;
  NSArray *invalidProducts = response.invalidProductIdentifiers;
  
  for (NSString *identifier in invalidProducts) {
    NSLog(@"Invalid identifier: %@", identifier);
  }
  
  // Sort products by price
  skProducts = [skProducts sortedArrayUsingComparator:^NSComparisonResult(id prod1, id prod2) {
    return [[prod1 price] floatValue] > [[prod2 price] floatValue];
  }];
  
  _completionHandler(YES, skProducts);
  _completionHandler = nil;
  
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
  
  _productsRequest = nil;
  
  _completionHandler(NO, nil);
  _completionHandler = nil;
}

@end
