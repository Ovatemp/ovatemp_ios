//
//  ApplePayHelper.h
//  Ovatemp
//
//  Created by Daniel Lozano on 5/14/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@import PassKit;

@protocol ApplePayHelperDelegate <NSObject>

/// Called when PKPaymentAuthorizationViewControllerDidFinish delegate method is called.
- (void)didFinish;

@end

@interface ApplePayHelper : NSObject

/// Delegate
@property (weak, nonatomic) id<ApplePayHelperDelegate> delegate;

/// Style for the PKPaymentButton that will be returned in the paymentButton method. Default is PKPaymentButtonStyleBlack.
@property (nonatomic) PKPaymentButtonStyle paymentButtonStyle;

/**
 *  Initializes ApplePayHelper class
 *
 *  @param viewController This is the view controller that the PKPaymentAuthorizationViewController is going to be presented on.
 *
 *  @return Fully initialized ApplePayHelper class
 */
- (id)initWithViewController:(UIViewController *)viewController;

/**
 *  Creates a PKPaymentButton instance
 *
 *  @return PKPaymentButton instance. Needs to be added as a subview to activate the payment proccess.
 */
- (UIButton *)paymentButton;

/**
 *  Starts the payment proccess by presenting the PKPaymentAuthorizationViewController.
 */
- (void)proccessPayment;

@end
