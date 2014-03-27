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

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.purchased = FALSE;
  self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (IBAction)buyTapped:(id)sender {
  NSLog(@"buy tapped");
  _purchased = TRUE;

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
  if([self showPurchaseScreen]) {
    return;
  }

  BOOL hasFertilityProfile = [User current].fertilityProfileId != nil;
  BOOL hasSeenIntro = [[Configuration sharedConfiguration].hasSeenProfileIntroScreen boolValue];

  if(hasFertilityProfile && hasSeenIntro) {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"CoachingMenuViewController"] animated:FALSE];
    return;
  }

  if(!hasFertilityProfile) {
    // Show quiz
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"QuizViewController"] animated:FALSE];

    return;
  }

  if(!hasSeenIntro) {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileIntroScreen"] animated:FALSE];

    [Configuration sharedConfiguration].hasSeenProfileIntroScreen = [NSNumber numberWithBool:TRUE];

    return;
  }
}

- (BOOL)showPurchaseScreen {
  return !self.purchased;
}


@end
