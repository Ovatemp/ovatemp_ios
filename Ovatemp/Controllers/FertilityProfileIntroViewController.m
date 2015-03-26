//
//  FertilityProfileIntroViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/27/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "FertilityProfileIntroViewController.h"
#import "User.h"

@interface FertilityProfileIntroViewController ()

@end

@implementation FertilityProfileIntroViewController

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;

  NSString *profileName = [[User current].fertilityProfileName capitalizedString];
  self.profileLabel.text = profileName;
  self.profileImageView.image = [UIImage imageNamed:profileName];
}

- (IBAction)nextTapped:(id)sender {
  [self.navigationController popViewControllerAnimated:FALSE];
}

@end
