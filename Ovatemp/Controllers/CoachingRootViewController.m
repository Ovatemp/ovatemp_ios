//
//  CoachingRootViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/25/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CoachingRootViewController.h"

@interface CoachingRootViewController ()

@end

@implementation CoachingRootViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.navigationController.delegate = self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (IBAction)buyTapped:(id)sender {
  NSLog(@"buy tapped");
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
  [viewController viewWillAppear:animated];

  if(viewController != self) {
    return;
  }

  if([self showPurchaseScreen]) {
    return;
  }

  [navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"CoachingMenuViewController"] animated:FALSE];
}

- (BOOL)showPurchaseScreen {
  return FALSE;
}


@end
