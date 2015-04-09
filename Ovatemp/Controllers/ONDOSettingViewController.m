//
//  ONDOSettingViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/9/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ONDOSettingViewController.h"

#import "ONDO.h"

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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool: YES forKey: @"ShouldScanForOndo"];
    [userDefaults synchronize];
    
    [ondo startScan];
}

- (void)ondoStopScan
{
    ONDO *ondo = [ONDO sharedInstance];
    
    if (!ondo.isScanning) {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool: NO forKey: @"ShouldScanForOndo"];
    [userDefaults synchronize];
    
    [ondo stopScan];
}

@end
