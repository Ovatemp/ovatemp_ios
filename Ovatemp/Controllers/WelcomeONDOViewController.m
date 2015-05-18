//
//  WelcomeONDOViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/20/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "WelcomeONDOViewController.h"
#import "ONDO.h"
#import "WebViewController.h"
#import "ONDOSettingViewController.h"
#import "ApplePayHelper.h"

@import PassKit;

#import "TAOverlay.h"
#import "Localytics.h"
#import <CCMPopup/CCMPopupTransitioning.h>

@interface WelcomeONDOViewController () <ONDODelegate>

@property (nonatomic) ApplePayHelper *applePayHelper;
@property (nonatomic) PKPaymentButton *payButton;

@end

@implementation WelcomeONDOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ApplePayHelper *applePayhelper = [[ApplePayHelper alloc] initWithViewController: self];
    applePayhelper.paymentButtonStyle = PKPaymentButtonStyleWhiteOutline;
    self.applePayHelper = applePayhelper;
    
    [self addApplePayButton];
    [self customizeAppearance];
    [self setUserDefaultsCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setUserDefaultsCount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger: 4 forKey: @"OnboardingCompletionCount"];
    [userDefaults synchronize];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    NSDictionary *viewsDictionary = @{@"yesButton" : self.yesButton,
                                      @"whiteSpace" : self.whiteSpace,
                                      @"payButton" : self.payButton};
    
    NSArray *buttonHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"H:|-20-[payButton]-20-|"
                                                                                   options: 0
                                                                                   metrics: nil
                                                                                     views: viewsDictionary];
    
    NSArray *buttonVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat: @"V:[whiteSpace]-10-[payButton(==40)]-10-[yesButton]"
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
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject: [UIColor ovatempDarkGreyTitleColor]
                                                                                              forKey: NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor ovatempAquaColor];
}

- (void)addApplePayButton
{
    self.payButton = [self.applePayHelper paymentButton];
    [self.view addSubview: self.payButton];
}

- (IBAction)doONDOPairing:(id)sender
{
    [self ondoStartScan];
    
    [Localytics tagEvent: @"User Did Pair ONDO on Sign Up"];
}

- (IBAction)doNoPairing:(id)sender
{
    [self ondoStopScan];
    
    [self performSegueWithIdentifier:@"toAlarm" sender:self];
//    [self backOutToRootViewController];
}

- (IBAction)doLearnMoreAboutONDO:(id)sender {
    NSString *url = @"http://ovatemp.com/pages/ondo";
    WebViewController *webViewController = [WebViewController withURL:url];
    webViewController.title = @"ONDO";
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - ONDO

- (void)ondoStartScan
{
    ONDO *ondo = [ONDO sharedInstance];
    
    [self showFakePairing];
    
    if (ondo.isScanning) {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool: YES forKey: @"ShouldScanForOndo"];
    [userDefaults synchronize];
    
    [ondo startScan];
}

- (void)ondoStopScan
{
    ONDO *ondo = [ONDO sharedInstance];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool: NO forKey: @"ShouldScanForOndo"];
    [userDefaults synchronize];
    
    if (!ondo.isScanning) {
        return;
    }
    
    [ondo stopScan];
}

#pragma mark - Pairing

- (void)showFakePairing
{
    [TAOverlay showOverlayWithLabel: @"Pairing with ONDO..." Options: TAOverlayOptionOverlayDismissTap];
    [self performSelector: @selector(showSuccessfull) withObject: self afterDelay: 1];
}

- (void)showSuccessfull
{
    [TAOverlay showOverlayWithLabel: @"Pairing successful!" Options: TAOverlayOptionAutoHide | TAOverlayOptionOverlayTypeSuccess];
    
    [self performSegueWithIdentifier:@"toAlarm" sender:self];
}

@end
