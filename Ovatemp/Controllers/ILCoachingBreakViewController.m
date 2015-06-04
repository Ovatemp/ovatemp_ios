//
//  ILCoachingBreakViewController.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/3/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCoachingBreakViewController.h"

@interface ILCoachingBreakViewController ()

@end

@implementation ILCoachingBreakViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeAppearance];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden: YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden: NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.title = @"Coaching";
    
    CGFloat percentageComplete = (float)self.currentQuestion / 112 * 100;
    
    self.headingLabel.text = [NSString stringWithFormat: @"Great now your profile is %.f%% complete. The more accurate your profile the more detailed our instructions and tips will get.", percentageComplete];
}

- (IBAction)didSelectYes:(id)sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (IBAction)didSelectNo:(id)sender
{
    // Do what? Maybe remove...
}

@end
