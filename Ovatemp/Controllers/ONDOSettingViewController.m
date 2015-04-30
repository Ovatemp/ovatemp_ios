//
//  ONDOSettingViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/9/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ONDOSettingViewController.h"

#import "ONDO.h"
#import "TAOverlay.h"

@interface ONDOSettingViewController ()

@end

@implementation ONDOSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ondoSwitch.onTintColor = [UIColor ovatempAquaColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    ONDO *ondo = [ONDO sharedInstance];
    
    if (ondo.isScanning) {
        [self.ondoSwitch setOn: YES];
    }else{
        [self.ondoSwitch setOn: NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBAction's

- (IBAction)ondoSwitchChanged:(id)sender
{
    if ([sender isOn]) {
        [self ondoStartScan];
    }else{
        [self ondoStopScan];
    }
}

#pragma mark - ONDO

- (void)ondoStartScan
{
    ONDO *ondo = [ONDO sharedInstance];
    
    if (ondo.isScanning) {
        return;
    }
    
    if ([self.delegate respondsToSelector: @selector(ondoSwitchedToState:)]) {
        [self.delegate ondoSwitchedToState: YES];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool: YES forKey: @"ShouldScanForOndo"];
    [userDefaults synchronize];
    
    [ondo startScan];

    [TAOverlay showOverlayWithLabel: @"Pairing with ONDO..." Options: TAOverlayOptionOverlayDismissTap | TAOverlayOptionOverlaySizeRoundedRect];
    [self performSelector: @selector(showSuccessfull) withObject: self afterDelay: 1];
}

- (void)showSuccessfull
{
    [TAOverlay showOverlayWithLabel: @"Pairing successful!" Options: TAOverlayOptionAutoHide | TAOverlayOptionOverlayTypeSuccess | TAOverlayOptionOverlaySizeRoundedRect];
}

- (void)ondoStopScan
{
    ONDO *ondo = [ONDO sharedInstance];
    
    if (!ondo.isScanning) {
        return;
    }
    
    if ([self.delegate respondsToSelector: @selector(ondoSwitchedToState:)]) {
        [self.delegate ondoSwitchedToState: NO];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool: NO forKey: @"ShouldScanForOndo"];
    [userDefaults synchronize];
    
    [ondo stopScan];
}

@end
