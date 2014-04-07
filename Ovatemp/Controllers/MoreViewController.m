//
//  MoreViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "MoreViewController.h"
#import "User.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewWillLayoutSubviews {
  [self updateControls];
}

- (IBAction)logoutTapped:(id)sender {
  [Configuration logOut];
  [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)tryingToConceiveChanged:(UISwitch *)toggle {
  [UserProfile current].tryingToConceive = [NSNumber numberWithBool:self.tryingToConceive.on];
  [[UserProfile current] save];

  [self updateControls];
}

- (IBAction)tryingToAvoidChanged:(UISwitch *)toggle {
  [UserProfile current].tryingToConceive = [NSNumber numberWithBool:!self.tryingToAvoid.on];
  [[UserProfile current] save];

  [self updateControls];
}

-(void)updateControls {
  self.tryingToConceive.on = [[UserProfile current].tryingToConceive boolValue];
  self.tryingToAvoid.on =   ![[UserProfile current].tryingToConceive boolValue];
  self.fullNameLabel.text = [[UserProfile current] fullName];
}

- (IBAction)resetFertilityProfile:(id)sender {

  [Configuration sharedConfiguration].hasSeenProfileIntroScreen = @NO;
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
