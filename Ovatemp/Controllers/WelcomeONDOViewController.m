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

#import <sys/utsname.h> // for device name
#import "Localytics.h"

@interface WelcomeONDOViewController () <ONDODelegate>

@end

@implementation WelcomeONDOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customizeAppearance];
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
//    ONDOViewController *ondoVC = [[ONDOViewController alloc] init];
//    [self.navigationController pushViewController:ondoVC animated:YES];
    __weak WelcomeONDOViewController *controller = self;
    //[ONDO showPairingWizardWithDelegate:controller];
//    [self backOutToRootViewController];
    
    [Localytics tagEvent: @"User Did Pair ONDO on Sign Up"];
    [self performSegueWithIdentifier:@"toAlarm" sender:self];
}

- (IBAction)doNoPairing:(id)sender
{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
