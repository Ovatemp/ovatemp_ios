//
//  WelcomeONDOViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/20/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "WelcomeONDOViewController.h"
#import "ONDO.h"

@interface WelcomeONDOViewController () <ONDODelegate>

@end

@implementation WelcomeONDOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doONDOPairing:(id)sender {
//    ONDOViewController *ondoVC = [[ONDOViewController alloc] init];
//    [self.navigationController pushViewController:ondoVC animated:YES];
    __weak WelcomeONDOViewController *controller = self;
    [ONDO showPairingWizardWithDelegate:controller];
}

- (IBAction)doNoPairing:(id)sender {
    [self backOutToRootViewController];
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
