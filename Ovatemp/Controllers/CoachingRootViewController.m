//
//  CoachingRootViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/25/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CoachingRootViewController.h"
#import "User.h"

@interface CoachingRootViewController ()
@property BOOL purchased;
@end

@implementation CoachingRootViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // TODO: Remove the 30 day free trial and update this
  self.purchased = [[Configuration sharedConfiguration].hasSeenProfileIntroScreen boolValue];
  self.navigationController.delegate = self;
  self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self trackScreenView:@"CoachingIntro"];
}

- (IBAction)buyTapped:(id)sender {
  _purchased = TRUE;

  [self trackEvent:@"ui_action" action:@"tap" label:@"buy_button" value:@(29.99)];
  [self pushAppropriateController];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  [viewController viewWillAppear:animated];

  if(viewController != self) {
    return;
  }

  [self pushAppropriateController];
}

- (void)pushAppropriateController {
  if ([self showPurchaseScreen]) {
    return;
  }

  BOOL hasFertilityProfile = [User current].fertilityProfileName != nil;
  BOOL hasSeenIntro = [[Configuration sharedConfiguration].hasSeenProfileIntroScreen boolValue];

  if(!hasFertilityProfile) {
    // Show quiz
    UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"];
    [self.navigationController pushViewController:controller animated:FALSE];

    return;
  }

  if(!hasSeenIntro) {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileIntroScreen"] animated:FALSE];

    [Configuration sharedConfiguration].hasSeenProfileIntroScreen = @YES;

    return;
  }

  if(hasFertilityProfile && hasSeenIntro) {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"CoachingMenuViewController"] animated:FALSE];
    return;
  }
}

- (BOOL)showPurchaseScreen {
  return !self.purchased;
}


@end
