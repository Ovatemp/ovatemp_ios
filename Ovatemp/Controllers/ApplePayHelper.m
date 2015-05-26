//
//  ApplePayHelper.m
//  Ovatemp
//
//  Created by Daniel Lozano on 5/14/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ApplePayHelper.h"

#import "Stripe.h"
#import "Stripe+ApplePay.h"

#import "PaymentHelper.h"
#import "OvatempAPI.h"

@interface ApplePayHelper () <PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic) NSDecimalNumber *totalAmount;
@property (nonatomic) UIViewController *viewController;

@end

@implementation ApplePayHelper

#pragma mark - Initialization

- (id)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        self.viewController = viewController;
    }
    return self;
}

#pragma mark - Apple Pay / Stripe

- (PKPaymentButton *)paymentButton
{
    PKPaymentButton *paymentButton = [PKPaymentButton buttonWithType: PKPaymentButtonTypeBuy style: self.paymentButtonStyle];
    paymentButton.frame = CGRectMake(0, 0, 0, 0);
    paymentButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [paymentButton addTarget: self action: @selector(proccessPayment) forControlEvents: UIControlEventTouchUpInside];
    
    return paymentButton;
}

- (void)proccessPayment
{
    PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier: @"merchant.com.ovatemp"];
    paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
    paymentRequest.requiredShippingAddressFields = PKAddressFieldAll;
    
    NSArray *shippingMethods = [self shippingMethods];
    paymentRequest.shippingMethods = shippingMethods;
    paymentRequest.paymentSummaryItems = [self paymentSummaryItemsForShippingMethod: shippingMethods[0]];
    
    if ([Stripe canSubmitPaymentRequest: paymentRequest]) {
        PKPaymentAuthorizationViewController *paymentController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: paymentRequest];
        paymentController.delegate = self;
        
        [self.viewController presentViewController: paymentController animated: YES completion: nil];
        
    } else {
        DDLogWarn(@"APPLE PAY NOT SUPPORTED.");
        // Show the user your own credit card form (see options 2 or 3)
    }
}

- (NSArray *)shippingMethods
{
    PKShippingMethod *freeShipping = [PKShippingMethod summaryItemWithLabel: @"Free Shipping" amount: [NSDecimalNumber decimalNumberWithString: @"0"]];
    freeShipping.identifier = @"freeShipping";
    freeShipping.detail = @"Arrives in 1 week.";
    
    PKShippingMethod *expressShipping = [PKShippingMethod summaryItemWithLabel: @"Express Shipping" amount: [NSDecimalNumber decimalNumberWithString: @"15"]];
    expressShipping.identifier = @"expressShipping";
    expressShipping.detail = @"Arrives in 2-3 days";
    
    return @[freeShipping, expressShipping];
}

- (NSArray *)paymentSummaryItemsForShippingMethod:(PKShippingMethod *)shipping
{
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString: @"75"];
    PKPaymentSummaryItem *ONDOitem = [PKPaymentSummaryItem summaryItemWithLabel: @"ONDO Thermometer" amount: amount];
    
    NSDecimalNumber *totalAmount = [ONDOitem.amount decimalNumberByAdding: shipping.amount];
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel: @"Ovatemp" amount: totalAmount];
    
    self.totalAmount = totalAmount;
    
    return @[ONDOitem, shipping, total];
}

- (void)handlePaymentAuthorizationWithPayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    [[STPAPIClient sharedClient] createTokenWithPayment:payment
                                             completion:^(STPToken *token, NSError *error) {
                                                 if (error) {
                                                     completion(PKPaymentAuthorizationStatusFailure);
                                                     return;
                                                 }
                                                 [self createBackendChargeWithToken: token payment: payment completion: completion];
                                             }];
}

- (void)createBackendChargeWithToken:(STPToken *)token payment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    [[OvatempAPI sharedSession] createBackendChargeWithToken: token
                                                     payment: payment
                                                      amount: self.totalAmount
                                                  completion:^(id object, NSError *error) {
                                                      
                                                      if (error) {
                                                          completion(PKPaymentAuthorizationStatusFailure);
                                                          return;
                                                      }
                                                      completion(PKPaymentAuthorizationStatusSuccess);
                                                      
                                                  }];
    
}

#pragma mark - PKPaymentAuthorizationViewController Delegate

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                completion:(void (^)(PKPaymentAuthorizationStatus, NSArray *))completion
{
    completion(PKPaymentAuthorizationStatusSuccess, [self paymentSummaryItemsForShippingMethod: shippingMethod]);
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    if ([self validateInformation: payment withCompletion: completion]) {
        [self handlePaymentAuthorizationWithPayment: payment completion: completion];
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    if ([self.delegate respondsToSelector: @selector(didFinish)]) {
        [self.delegate didFinish];
    }
    
    [controller dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Validation

- (BOOL)validateInformation:(PKPayment *)payment withCompletion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    if (![PaymentHelper validEmailForPayment: payment]) {
        completion(PKPaymentAuthorizationStatusInvalidShippingContact);
        return NO;
    }
    
    if (![PaymentHelper validPhoneForPayment: payment]) {
        completion(PKPaymentAuthorizationStatusInvalidShippingContact);
        return NO;
    }
    
    if (![PaymentHelper validFullNameForpayment: payment]) {
        completion(PKPaymentAuthorizationStatusInvalidShippingPostalAddress);
        return NO;
    }
    
    if (![PaymentHelper validShippingAddressForPayment: payment]) {
        completion(PKPaymentAuthorizationStatusInvalidShippingPostalAddress);
        return NO;
    }
    
    return YES;
}

#pragma mark - Set/Get

- (PKPaymentButtonStyle)paymentButtonStyle
{
    if (!_paymentButtonStyle) {
        _paymentButtonStyle = PKPaymentButtonStyleBlack;
    }
    return _paymentButtonStyle;
}

@end
