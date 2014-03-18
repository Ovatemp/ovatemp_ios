//
//  FAMSettingsViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "FAMSettingsViewController.h"
#import "UserProfile.h"

@interface FAMSettingsViewController ()

@end

@implementation FAMSettingsViewController

- (void)viewWillLayoutSubviews {
  [self updateControls];
}

- (IBAction)fiveDayRuleSwitched:(id)sender {
  [UserProfile current].fiveDayRule = [NSNumber numberWithBool:self.fiveDayRuleSwitch.on];
  [self commit];
}
- (IBAction)dryDayRuleSwitched:(id)sender {
  [UserProfile current].dryDayRule = [NSNumber numberWithBool:self.dryDayRuleSwitch.on];
  [self commit];
}

- (IBAction)tempShiftRuleSwitched:(id)sender {
  [UserProfile current].temperatureShiftRule = [NSNumber numberWithBool:self.tempShiftRuleSwitch.on];
  [self commit];
}

- (IBAction)peakDayRuleSwitched:(id)sender {
  [UserProfile current].peakDayRule = [NSNumber numberWithBool:self.peakDayRuleSwitch.on];
  [self commit];
}

- (void)commit {
  [[UserProfile current] save];
  [self updateControls];
}

- (void)updateControls {
  self.fiveDayRuleSwitch.on =   [[UserProfile current].fiveDayRule boolValue];
  self.dryDayRuleSwitch.on =    [[UserProfile current].dryDayRule boolValue];
  self.tempShiftRuleSwitch.on = [[UserProfile current].temperatureShiftRule boolValue];
  self.peakDayRuleSwitch.on =   [[UserProfile current].peakDayRule boolValue];
}

@end
