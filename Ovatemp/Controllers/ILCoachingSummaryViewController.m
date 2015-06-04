//
//  ILCoachingSummaryViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCoachingSummaryViewController.h"

@interface ILCoachingSummaryViewController ()

@end

@implementation ILCoachingSummaryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.title = @"Coaching";
    
    [self.navigationItem setHidesBackButton: YES animated: YES];
}

@end
