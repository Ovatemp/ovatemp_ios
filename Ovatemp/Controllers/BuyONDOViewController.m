//
//  BuyONDOViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 5/5/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

@import PassKit;

#import "ApplePayStubs.h"
#import "Stripe.h"
#import "Stripe+ApplePay.h"

#import "OvatempAPI.h"

#import "BuyONDOViewController.h"

@interface BuyONDOViewController () <PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic) PKPaymentButton *payButton;
@property (nonatomic) NSDecimalNumber *totalAmount;

@end

@implementation BuyONDOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeAppearance];
    [self addApplePayButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    NSDictionary *viewsDictionary = @{@"imageView" : self.ondoImageView,
                                      @"payButton" : self.payButton};
    
    NSArray *buttonHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-10-[payButton]-10-|"
                                                                                  options: 0
                                                                                  metrics: nil
                                                                                    views: viewsDictionary];
    
    NSArray *buttonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:[imageView]-20-[payButton(==50)]"
                                                                                options: 0
                                                                                metrics: nil
                                                                                  views: viewsDictionary];
    
    NSLayoutConstraint *buttonCenterConstraint =   [NSLayoutConstraint constraintWithItem: self.payButton
                                                                                attribute: NSLayoutAttributeCenterX
                                                                                relatedBy: NSLayoutRelationEqual
                                                                                   toItem: self.view
                                                                                attribute: NSLayoutAttributeCenterX
                                                                               multiplier: 1
                                                                                 constant: 0];
    
    [self.view addConstraints: buttonHorizontalConstraints];
    [self.view addConstraints: buttonVerticalConstraints];
    [self.view addConstraint: buttonCenterConstraint];
}

#pragma mark - IBAction's

- (void)didSelectCancel
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.title = @"Buy ONDO";
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(didSelectCancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)addApplePayButton
{
    self.payButton = [PKPaymentButton buttonWithType: PKPaymentButtonTypeBuy style: PKPaymentButtonStyleBlack];
    self.payButton.frame = CGRectMake(0, 0, 0, 0);
    self.payButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.payButton addTarget: self action: @selector(proccessPayment) forControlEvents: UIControlEventTouchUpInside];
    
    [self.view addSubview: self.payButton];
}

#pragma mark - Apple Pay / Stripe

- (void)proccessPayment
{
    PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier: @"merchant.com.ovatemp"];
    paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
    paymentRequest.requiredShippingAddressFields = PKAddressFieldAll;
    
    NSArray *shippingMethods = [self shippingMethods];
    paymentRequest.shippingMethods = shippingMethods;
    paymentRequest.paymentSummaryItems = [self paymentSummaryItemsForShippingMethod: shippingMethods[0]];
    
    if ([Stripe canSubmitPaymentRequest: paymentRequest]) {
        
        DDLogInfo(@"STRIPE CAN SUBMIT");
        
        UIViewController *paymentController;
        
//        #ifdef STAGING_DEBUG
//            paymentController = [[STPTestPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
//            ((STPTestPaymentAuthorizationViewController *)paymentController).delegate = self;
//        #elif STAGING_RELEASE
//            paymentController = [[STPTestPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
//            ((STPTestPaymentAuthorizationViewController *)paymentController).delegate = self;
//        #elif PRODUCTION_DEBUG
//            paymentController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
//            ((PKPaymentAuthorizationViewController *)paymentController).delegate = self;
//        #elif PRODUCTION_RELEASE
            paymentController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest: paymentRequest];
            ((PKPaymentAuthorizationViewController *)paymentController).delegate = self;
//        #endif
        
        [self presentViewController: paymentController animated: YES completion: nil];
        
    } else {
        DDLogError(@"STRIPE CAN NOT SUBMIT");
        // Show the user your own credit card form (see options 2 or 3)
    }
}

- (NSArray *)shippingMethods
{
    PKShippingMethod *freeShipping = [PKShippingMethod summaryItemWithLabel: @"Free Shipping" amount: [NSDecimalNumber decimalNumberWithString: @"0"]];
    freeShipping.identifier = @"freeShipping";
    freeShipping.detail = @"Arrives in 6-8 weeks.";
    
    PKShippingMethod *expressShipping = [PKShippingMethod summaryItemWithLabel: @"Express Shipping" amount: [NSDecimalNumber decimalNumberWithString: @"10"]];
    expressShipping.identifier = @"expressShipping";
    expressShipping.detail = @"Arrives in 2-3 days";
    
    return @[freeShipping, expressShipping];
}

- (NSArray *)paymentSummaryItemsForShippingMethod:(PKShippingMethod *)shipping
{
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString: @"75.00"];
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
                                                 [self createBackendChargeWithToken: token completion: completion];
                                             }];
}

- (void)createBackendChargeWithToken:(STPToken *)token completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    [[OvatempAPI sharedSession] createBackendChargeWithToken: token amount: self.totalAmount completion:^(id object, NSError *error) {
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
    [self handlePaymentAuthorizationWithPayment: payment completion: completion];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

@end
