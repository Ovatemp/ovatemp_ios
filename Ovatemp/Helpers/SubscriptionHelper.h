//
//  SubscriptionHelper.h
//  Ovatemp
//
//  Created by Ed Schmalzle on 6/24/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);
UIKIT_EXTERN NSString *const SubscriptionHelperProductPurchasedNotification;

@interface SubscriptionHelper : NSObject

-(id)init;

+ (SubscriptionHelper*) sharedInstance;

- (BOOL) hasActiveSubscription;
- (void) requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void) restorePurchases;

@end
