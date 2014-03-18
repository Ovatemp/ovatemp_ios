//
//  ProfileSettingsViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ProfileSettingsViewController.h"
#import "UserProfile.h"

@interface ProfileSettingsViewController ()

@end

@implementation ProfileSettingsViewController

- (void)viewDidLoad {
  self.dateOfBirthTextField.inputView = self.datePicker;
  self.datePicker.maximumDate = [NSDate date];
}

- (void)viewWillLayoutSubviews {
  [self updateControls];
}

- (IBAction)dateOfBirthPickerChanged:(UIDatePicker *)sender {
  [UserProfile current].dateOfBirth = self.datePicker.date;
  [self commit];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];

  return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if(textField == self.fullNameTextField) {
    [UserProfile current].fullName = textField.text;
  }

  [self commit];
}

- (void)updateControls {
  self.dateOfBirthTextField.inputView = self.datePicker;


  if([[UserProfile current] dateOfBirth]) {
    self.datePicker.date = [[UserProfile current] dateOfBirth];
  }
  self.dateOfBirthTextField.text = [[[UserProfile current] dateOfBirth] classicDate];
  self.fullNameTextField.text = [[UserProfile current] fullName];
}

- (void)commit {
  [[UserProfile current] save];
  [self updateControls];
}

@end
