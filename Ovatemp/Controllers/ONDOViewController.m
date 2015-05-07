//
//  ONDOViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/15/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ONDOViewController.h"

@import PassKit;

#import <CCMPopup/CCMPopupTransitioning.h>
#import "ApplePayStubs.h"
#import "Stripe.h"
#import "Stripe+ApplePay.h"

#import "ONDO.h"
#import "OvatempAPI.h"
#import "AccountTableViewCell.h"
#import "WebViewController.h"
#import "ONDOSettingViewController.h"
#import "TutorialHelper.h"

@interface ONDOViewController () <UITableViewDelegate, UITableViewDataSource,PKPaymentAuthorizationViewControllerDelegate, ONDODelegate, ONDOSettingsViewControllerDelegate>

@property AccountTableViewCell *accountTableViewCell;
@property (nonatomic) BOOL ondoSwitchedState;

@property (nonatomic) PKPaymentButton *payButton;
@property (nonatomic) NSDecimalNumber *totalAmount;

@end

@implementation ONDOViewController

NSArray *ondoMenuItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self customizeAppearance];
    [self addApplePayButton];
    
    ondoMenuItems = @[@"Setup ONDO", @"About ONDO", @"Instruction Manual"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    if (self.ondoSwitchedState) {
        self.ondoSwitchedState = NO;
        [TutorialHelper showTutorialForOndoInController: self];
    }
}

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    NSDictionary *viewsDictionary = @{@"label" : self.ondoLabel,
                                      @"tableView" : self.tableView,
                                      @"payButton" : self.payButton};
    
    NSArray *buttonHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-10-[payButton]-10-|"
                                                                                   options: 0
                                                                                   metrics: nil
                                                                                     views: viewsDictionary];
    
    NSArray *buttonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:[label]-10-[payButton(==45)]-10-[tableView]"
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

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.title = @"ONDO";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [[self tableView] registerNib:[UINib nibWithNibName:@"AccountTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"accountCell"];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [ondoMenuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountCell" forIndexPath:indexPath];
    [[cell textLabel] setText:[ondoMenuItems objectAtIndex:indexPath.row]];
    cell.layoutMargins = UIEdgeInsetsZero;
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            // Pair
            
            ONDOSettingViewController *ondoSettingVC = [[ONDOSettingViewController alloc] init];
            ondoSettingVC.delegate = self;
            
            CCMPopupTransitioning *popup = [CCMPopupTransitioning sharedInstance];
            popup.destinationBounds = CGRectMake(0, 0, 200, 200);
            popup.presentedController = ondoSettingVC;
            popup.presentingController = self;
            popup.dismissableByTouchingBackground = YES;
            popup.backgroundViewColor = [UIColor blackColor];
            popup.backgroundViewAlpha = 0.5f;
            popup.backgroundBlurRadius = 0;
            
            ondoSettingVC.view.layer.cornerRadius = 5;
            
            [self presentViewController: ondoSettingVC animated: YES completion: nil];
            
            break;
        }
            
        case 1: // About
        {
            NSString *url = @"http://ovatemp.com/pages/ondo";
            WebViewController *webViewController = [WebViewController withURL:url];
            webViewController.title = @"About ONDO";
            [self.navigationController pushViewController:webViewController animated:YES];
            break;
        }
            
        case 2: // Instructions
        {
            NSString *url = @"https://s3.amazonaws.com/ovatemp/UserManual_2014.02.26.pdf";
            WebViewController *webViewController = [WebViewController withURL:url];
            webViewController.title = @"Instruction Manual";
            [self.navigationController pushViewController:webViewController animated:YES];
            break;
        }
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - ONDOSettingsViewController Delegate

- (void)ondoSwitchedToState:(BOOL)state
{
    self.ondoSwitchedState = state;
}

@end
