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

#import "Form.h"

@interface ProfileSettingsViewController ()

@property Form *form;

@end

@implementation ProfileSettingsViewController

- (void)viewDidLoad {
  self.form = [Form withViewController:self];
  // TODO: if fullName is an empty string, initialize the form with 10 whitespace characters or something.
  if (![UserProfile current].fullName) {
      [UserProfile current].fullName = @"          ";
  }
  self.form.representedObject = [UserProfile current];
  self.form.onChange = ^(Form *form, FormRow *row, id value) {
    [[UserProfile current] save];
  };
  
  [self.form addKeyPath:@"fullName" withLabel:@"Full Name:" toSection:@"Profile Settings"];

  NSInteger minAgeInYears = 12;
  NSInteger day = 60 * 60 * 24;
  NSInteger year = day * 365;
  NSDate *maximumDate = [NSDate dateWithTimeIntervalSinceNow:-minAgeInYears * year];
  NSDate *minimumDate = [NSDate dateWithTimeIntervalSinceNow:-50 * year];

  FormRow *birthDate = [self.form addKeyPath:@"dateOfBirth"
                                   withLabel:@"Date of Birth:"
                                    andImage:@"MoreBirthday.png"
                                   toSection:@"Profile Settings"];
  birthDate.datePicker.datePickerMode = UIDatePickerModeDate;
  birthDate.datePicker.minimumDate = minimumDate;
  birthDate.datePicker.maximumDate = maximumDate;
}

- (void)viewDidAppear:(BOOL)animated {
  [self trackScreenView:@"Profile Settings"];
}

# pragma mark - Closing text inputs

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
