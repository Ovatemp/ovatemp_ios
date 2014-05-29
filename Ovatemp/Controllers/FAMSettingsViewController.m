//
//  FAMSettingsViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "FAMSettingsViewController.h"

#import "Form.h"
#import "UserProfile.h"

@interface FAMSettingsViewController ()

@property (nonatomic, strong) Form *form;

@end

@implementation FAMSettingsViewController

- (void)viewDidLoad {
  self.form = [Form withViewController:self];
  self.form.representedObject = [UserProfile current];
  self.form.onChange = ^(Form *form, FormRow *row, id value) {
    [[UserProfile current] save];
  };

  [self.form addKeyPath:@"fiveDayRule" withLabel:@"Five Day Rule:" toSection:@"FAM Settings"];
  [self.form addKeyPath:@"dryDayRule" withLabel:@"Dry Day Rule:" toSection:@"FAM Settings"];
  [self.form addKeyPath:@"temperatureShiftRule" withLabel:@"Temp Shift Rule:" toSection:@"FAM Settings"];
  [self.form addKeyPath:@"peakDayRule" withLabel:@"Peak Day Rule:" toSection:@"FAM Settings"];
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
