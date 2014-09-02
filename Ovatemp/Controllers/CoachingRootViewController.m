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

@implementation CoachingRootViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationController.delegate = self;
  self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self trackScreenView:@"CoachingIntro"];
}

- (IBAction)buyTapped:(id)sender {
  
  [self trackEvent:@"ui_action" action:@"tap" label:@"buy_button" value: @(29.99)];
  
  if([[SubscriptionHelper sharedInstance] hasActiveSubscription]) {
    [self pushAppropriateController];
  } else {
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SubscriptionSelectionViewController"];
    [self.navigationController pushViewController: controller animated:FALSE];
  }
  
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  [viewController viewWillAppear:animated];

  if(viewController != self) {
    return;
  }

  [self pushAppropriateController];
}

- (void)pushAppropriateController {

  if(![[SubscriptionHelper sharedInstance] hasActiveSubscription]) {
    return;
  }
  
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
