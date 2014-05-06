//
//  ProfileSettingsViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "ProfileSettingsViewController.h"
#import "UserProfile.h"
#import "UIViewController+UserProfileHelpers.h"

@interface ProfileSettingsViewController ()

@end

@implementation ProfileSettingsViewController

- (void)viewDidLoad {
  self.datePicker = [self useDatePickerForTextField:self.dateOfBirthTextField];
  NSInteger minAgeInYears = 12;
  NSInteger day = 60 * 60 * 24;
  NSInteger year = day * 365;
  NSDate *maximumDate = [NSDate dateWithTimeIntervalSinceNow:-minAgeInYears * year];
  NSDate *minimumDate = [NSDate dateWithTimeIntervalSinceNow:-50 * year];

  self.datePicker.minimumDate = minimumDate;
  self.datePicker.maximumDate = maximumDate;

  [self.datePicker addTarget:self
                      action:@selector(dateOfBirthPickerChanged:)
            forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
  [self trackScreenView:@"Profile Settings"];
}

- (void)viewWillLayoutSubviews {
  [self updateControls];
}

- (void)commit {
  [[UserProfile current] save];
  [self updateControls];
}

- (void)updateControls {
  self.dateOfBirthTextField.inputView = self.datePicker;

  if([[UserProfile current] dateOfBirth]) {
    self.datePicker.date = [[UserProfile current] dateOfBirth];
  }
  self.dateOfBirthTextField.text = [[[UserProfile current] dateOfBirth] classicDate];
  self.fullNameTextField.text = [UserProfile current].fullName;
}

- (IBAction)dateOfBirthPickerChanged:(UIDatePicker *)sender {
  [UserProfile current].dateOfBirth = self.datePicker.date;
  [self commit];
}

# pragma mark - Closing text inputs
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];

  return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if(textField == self.fullNameTextField) {
    [UserProfile current].fullName = textField.text;
  }

  [self commit];
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
