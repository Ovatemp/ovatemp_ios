//
//  SelectLogInOrSignUpViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SelectLogInOrSignUpViewController.h"
#import "WebViewController.h"

#import "TutorialHelper.h"

@interface SelectLogInOrSignUpViewController ()

@end

@implementation SelectLogInOrSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customizeAppearance];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden: YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    
    [self showWalkthrough];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor ovatempDarkGreyTitleColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,
                                    [UIFont fontWithName:@"LucidaSans" size:12], NSFontAttributeName,
                                    nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor ovatempAquaColor]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor ovatempAquaColor]];
}

#pragma mark - IBAction's

- (IBAction)doPresentTerms:(id)sender
{
    NSString *url = @"http://ovatemp.com/terms-of-service";
    WebViewController *webViewController = [WebViewController withURL:url];
    webViewController.title = @"Terms and Conditions";
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - Tutorial

- (void)showWalkthrough
{
    if ([TutorialHelper shouldShowAppWalkthrough]) {
        [TutorialHelper showAppWalkthroughInController: self];
    }
}

@end
