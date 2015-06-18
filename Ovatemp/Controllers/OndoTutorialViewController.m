//
//  OndoTutorialViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/17/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "OndoTutorialViewController.h"

#import "TAOverlay.h"

#import "ONDO.h"
#import "OndoTutorialImageViewController.h"

@interface OndoTutorialViewController () <ONDODelegate>

@end

@implementation OndoTutorialViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeAppearance];
    
    [self ondoStartScan];
    [self checkManagerStatus];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
    
    [ONDO sharedInstance].testDelegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Appearance / Initial Setup

- (void)customizeAppearance
{
    self.title = @"ONDO Setup";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor darkGrayColor]};

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                              UIBarButtonSystemItemDone target: self action: @selector(didSelectDone)];;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Back"
                                                                             style: UIBarButtonItemStyleDone
                                                                            target: nil
                                                                            action: nil];
    
    self.nextButton.alpha = 0.0f;
}

#pragma mark - ONDO

- (void)ondoStartScan
{
    ONDO *ondo = [ONDO sharedInstance];
    ondo.testDelegate = self;
    
    if (ondo.isScanning) {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool: YES forKey: @"ShouldScanForOndo"];
    [userDefaults synchronize];
    
    [ondo startScan];
}

- (void)checkManagerStatus
{
    CBCentralManagerState state = [[ONDO sharedInstance] centralManagerState];
    switch (state) {
        case CBCentralManagerStatePoweredOff:
            [self ONDOsaysBluetoothIsDisabled: nil];
            break;
        case CBCentralManagerStateResetting:
            [self ONDOsaysBluetoothIsDisabled: nil];
            break;
        case CBCentralManagerStateUnauthorized:
            break;
        case CBCentralManagerStateUnknown:
            break;
        case CBCentralManagerStateUnsupported:
            [self ONDOsaysLEBluetoothIsUnavailable: nil];
            break;
        case CBCentralManagerStatePoweredOn:
            break;
    }
}

#pragma mark - ONDO Delegate

- (void)ONDOsaysBluetoothIsDisabled:(ONDO *)ondo
{
    [self showWarningOverlayWithText: @"Bluetooth is off, so we can't detect a thing! Please, turn it on."];
}

- (void)ONDOsaysLEBluetoothIsUnavailable:(ONDO *)ondo
{
    [self showWarningOverlayWithText: @"Your device does not support Bluetooth LE, so it can't connect to your ONDO."];
}

- (void)ONDO:(ONDO *)ondo didEncounterError:(NSError *)error
{
    [self showErrorOverlayWithText: @"Error connecting to ONDO, please try again."];
}

- (void)ONDO:(ONDO *)ondo didConnectToDevice:(ONDODevice *)device
{
    [TAOverlay showOverlayWithLabel: @"Connected to ONDO"
                            Options: TAOverlayOptionOverlayDismissTap | TAOverlayOptionOverlaySizeRoundedRect];
}

- (void)ONDO:(ONDO *)ondo didReceiveTemperature:(CGFloat)temperature
{
    float tempInCelsius = temperature;
    float tempInFahrenheit = temperature * 9.0f / 5.0f + 32.0f;
    
    if ((tempInCelsius < 0) || (tempInFahrenheit < 0)) {
        [self showErrorOverlayWithText: @"Error connecting to ONDO, please try again."];
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL tempPrefFahrenheit = [defaults boolForKey: @"temperatureUnitPreferenceFahrenheit"];
    
    NSString *alertMessage;
    NSString *labelMessage;
    
    if (tempPrefFahrenheit) {
        alertMessage = [NSString stringWithFormat: @"Recorded a temperature of %.2fºF for today", tempInFahrenheit];
        labelMessage = [NSString stringWithFormat: @"Success! Your temperature was: %.2fºF. Click next to continue.", tempInFahrenheit];
        
    } else {
        alertMessage = [NSString stringWithFormat: @"Recorded a temperature of %.2fºC for today", tempInCelsius];
        labelMessage = [NSString stringWithFormat: @"Success! Your temperature was %.2fºC. Click next to continue.", tempInCelsius];
    }
    
    self.temperatureLabel.text = labelMessage;
    [self showSuccessOverlayWithText: alertMessage];
    
    [UIView animateWithDuration: 0.5 animations:^{
        self.nextButton.alpha = 1.0f;
    }];
}

#pragma mark - Overlay's

- (void)showSuccessOverlayWithText:(NSString *)text
{
    [TAOverlay showOverlayWithLabel: text
                            Options: TAOverlayOptionOverlayDismissTap | TAOverlayOptionOverlayTypeSuccess | TAOverlayOptionOverlaySizeRoundedRect];
}

- (void)showWarningOverlayWithText:(NSString *)text
{
    [TAOverlay showOverlayWithLabel: text
                            Options: TAOverlayOptionOverlayDismissTap | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionOverlayTypeWarning];

}

- (void)showErrorOverlayWithText:(NSString *)text
{
    [TAOverlay showOverlayWithLabel: text
                            Options: TAOverlayOptionOverlayDismissTap | TAOverlayOptionOverlaySizeRoundedRect | TAOverlayOptionOverlayTypeError];
}

#pragma mark - IBAction's

- (void)didSelectDone
{
    [ONDO sharedInstance].testDelegate = nil;

    [self dismissViewControllerAnimated: YES  completion: nil];
}

- (IBAction)didSelectNext:(id)sender
{
    [ONDO sharedInstance].testDelegate = nil;

    OndoTutorialImageViewController *tutorialImageVC = [self.storyboard instantiateViewControllerWithIdentifier: @"OndoTutorialImageViewController"];
    tutorialImageVC.index = 3;
    [self.navigationController pushViewController: tutorialImageVC animated: YES];
}

@end
