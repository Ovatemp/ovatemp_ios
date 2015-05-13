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

#import <sys/utsname.h> // for device name
#import "Localytics.h"
#import <CCMPopup/CCMPopupTransitioning.h>

@interface WelcomeONDOViewController () <ONDODelegate>

@end

@implementation WelcomeONDOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeAppearance];
    [self setUserDefaultsCount];
    
    // Do any additional setup after loading the view.
    NSLog(@"%@", machineName());
    NSString *deviceName = machineName();
    
    if ([deviceName isEqualToString:@"iPhone4,1"]) {
        // hide squished ondo image
        self.ondoImageView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUserDefaultsCount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger: 4 forKey: @"OnboardingCompletionCount"];
    [userDefaults synchronize];
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject: [UIColor ovatempDarkGreyTitleColor]
                                                                                              forKey: NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor ovatempAquaColor];
}

- (IBAction)doONDOPairing:(id)sender
{
    [self ondoStartScan];
    
    [Localytics tagEvent: @"User Did Pair ONDO on Sign Up"];
    [self performSegueWithIdentifier:@"toAlarm" sender:self];
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

NSString* machineName() {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool: NO forKey: @"ShouldScanForOndo"];
    [userDefaults synchronize];
    
    if (!ondo.isScanning) {
        return;
    }
    
    [ondo stopScan];
}

@end
