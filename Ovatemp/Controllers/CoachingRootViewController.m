//
//  CoachingRootViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/25/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CoachingRootViewController.h"
#import "User.h"
#import "SubscriptionHelper.h"
#import "SubscriptionSelectionController.h"

#import "Localytics.h"

@implementation CoachingRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self customizeAppearance];
    self.navigationController.delegate = self;
    //self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
    
    [Localytics tagScreen: @"Coaching"];
}

- (void)customizeAppearance
{
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject: [UIColor ovatempDarkGreyTitleColor]
                                                                                              forKey: NSForegroundColorAttributeName];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(247/255.0) green:(247/255.0) blue:(247/255.0) alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor ovatempAquaColor];
}

- (IBAction)buyTapped:(id)sender
{
    [self pushAppropriateController];
    
//    if([[SubscriptionHelper sharedInstance] hasActiveSubscription]) {
//        [self pushAppropriateController];
//    } else {
//        UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SubscriptionSelectionViewController"];
//        [self.navigationController pushViewController: controller animated: YES];
//    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  [viewController viewWillAppear:animated];

  if(viewController != self) {
    return;
  }
    
    if (self.showFirstScreen) {
        self.showFirstScreen = NO;
    }else{
        [self pushAppropriateController];
    }
}

- (void)pushAppropriateController
{

//  if(![[SubscriptionHelper sharedInstance] hasActiveSubscription]) {
//    return;
//  }
  
  BOOL hasFertilityProfile = [User current].fertilityProfileName != nil;
  BOOL hasSeenIntro = [[Configuration sharedConfiguration].hasSeenProfileIntroScreen boolValue];
  
  if(!hasFertilityProfile) {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
    [self.navigationController pushViewController:controller animated:FALSE];
    return;
  }

  if(!hasSeenIntro) {
    UIViewController *profileIntroViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileIntroScreen"];
    [self.navigationController pushViewController: profileIntroViewController animated:FALSE];
    [Configuration sharedConfiguration].hasSeenProfileIntroScreen = @YES;
    return;
  }

  if(hasFertilityProfile && hasSeenIntro) {
    UIViewController *coachingMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CoachingMenuViewController"];
    [self.navigationController pushViewController: coachingMenuViewController animated:FALSE];
    return;
  }
}

@end
