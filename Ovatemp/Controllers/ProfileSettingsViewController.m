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

  // If fullName is nil, initialize the form with a dummy name.
  if (![UserProfile current].fullName) {
      [UserProfile current].fullName = @"Jane Doe";
  }
    // dateOfBirth cannot be nil.  If for some reason it is nil, set the birthday to 12 years ago today (youngest age to use app).
  if (![UserProfile current].dateOfBirth) {
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateComponents *addComponents = [[NSDateComponents alloc] init];
    addComponents.year = -12;


    [UserProfile current].dateOfBirth = [calendar dateByAddingComponents:addComponents toDate:today options:0];
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

# pragma mark - Closing text inputs

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
