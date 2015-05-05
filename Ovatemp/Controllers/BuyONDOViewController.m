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

#import "BuyONDOViewController.h"

@interface BuyONDOViewController () <PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic) PKPaymentButton *payButton;

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
    
    NSString *label = @"ONDO Thermometer";
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString: @"75.00"];
    paymentRequest.paymentSummaryItems = @[[PKPaymentSummaryItem summaryItemWithLabel: label amount: amount]];
    
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

- (void)handlePaymentAuthorizationWithPayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    [[STPAPIClient sharedClient] createTokenWithPayment:payment
                                             completion:^(STPToken *token, NSError *error) {
                                                 if (error) {
                                                     completion(PKPaymentAuthorizationStatusFailure);
                                                     return;
                                                 }
                                                 /*
                                                  We'll implement this below in "Sending the token to your server".
                                                  Notice that we're passing the completion block through.
                                                  See the above comment in didAuthorizePayment to learn why.
                                                  */
                                                 [self createBackendChargeWithToken: token completion: completion];
                                             }];
}

- (void)createBackendChargeWithToken:(STPToken *)token completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    NSURL *url = [NSURL URLWithString:@"https://example.com/token"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *body     = [NSString stringWithFormat:@"stripeToken=%@", token.tokenId];
    request.HTTPBody   = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if (error) {
                                   completion(PKPaymentAuthorizationStatusFailure);
                               } else {
                                   completion(PKPaymentAuthorizationStatusSuccess);
                               }
                           }];
}

#pragma mark - PKPaymentAuthorizationViewController Delegate

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    /*
     We'll implement this method below in 'Creating a single-use token'.
     Note that we've also been given a block that takes a
     PKPaymentAuthorizationStatus. We'll call this function with either
     PKPaymentAuthorizationStatusSuccess or PKPaymentAuthorizationStatusFailure
     after all of our asynchronous code is finished executing. This is how the
     PKPaymentAuthorizationViewController knows when and how to update its UI.
     */
    [self handlePaymentAuthorizationWithPayment:payment completion:completion];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
