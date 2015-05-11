//
//  PaymentHelper.h
//  Ovatemp
//
//  Created by Daniel Lozano on 5/11/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Stripe.h"

@interface PaymentHelper : NSObject

+ (NSString *)emailForPayment:(PKPayment *)payment;
+ (NSString *)phoneForPayment:(PKPayment *)payment;
+ (NSString *)fullNameForPayment:(PKPayment *)payment;
+ (NSString *)shippingAddressForPayment:(PKPayment *)payment;

+ (BOOL)validEmailForPayment:(PKPayment *)payment;
+ (BOOL)validPhoneForPayment:(PKPayment *)payment;
+ (BOOL)validFullNameForpayment:(PKPayment *)payment;
+ (BOOL)validShippingAddressForPayment:(PKPayment *)payment;

@end
