//
//  Welcome1ViewController.m
//  Ovatemp
//
//  Created by Josh L on 10/20/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Welcome1ViewController.h"
#import "UserProfile.h"
#import "UIViewController+UserProfileHelpers.h"

#import "Localytics.h"

@interface Welcome1ViewController ()

@end

@implementation Welcome1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    [self customizeAppearance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didSelectTryingToConceive:(id)sender
{
    [UserProfile current].tryingToConceive = YES;
    [[UserProfile current] save];
    
    [Localytics tagEvent: @"User Is Trying To Conceive"];
    [self performSegueWithIdentifier:@"tryingToConceive" sender:self];
}

- (IBAction)didSelectTryingToAvoid:(id)sender {
    [UserProfile current].tryingToConceive = NO;
    [[UserProfile current] save];
    
    [Localytics tagEvent: @"User Is Trying To Avoid"];
    [self performSegueWithIdentifier:@"tryingToAvoid" sender:self];
}

#pragma mark - Appearance

- (void)customizeAppearance
{
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject: [UIColor ovatempDarkGreyTitleColor]
                                                                                              forKey: NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor ovatempAquaColor];
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
