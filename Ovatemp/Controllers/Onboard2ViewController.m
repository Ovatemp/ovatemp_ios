//
//  Onboard2ViewController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/19/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Onboard2ViewController.h"
#import "UserProfile.h"

@interface Onboard2ViewController ()

@end

@implementation Onboard2ViewController

- (void)viewDidLoad {
  self.dateOfBirthPicker = [self useDatePickerForTextField:self.dateOfBirthTextField];
  NSInteger minAgeInYears = 12;
  NSInteger day = 60 * 60 * 24;
  NSInteger year = day * 365;
  NSDate *maximumDate = [NSDate dateWithTimeIntervalSinceNow:-minAgeInYears * year];
  NSDate *minimumDate = [NSDate dateWithTimeIntervalSinceNow:-100 * year];

  self.dateOfBirthPicker.maximumDate = maximumDate;
  self.dateOfBirthPicker.minimumDate = minimumDate;

  [self.dateOfBirthPicker addTarget:self
                           action:@selector(dateOfBirthPickerChanged:)
                 forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
  [self addKeyboardObservers];
  [self trackScreenView:@"Signup Screen 1"];
}

- (void)viewDidDisappear:(BOOL)animated {
  [self removeKeyboardObservers];
}

- (void)viewWillLayoutSubviews {
  [self updateControls];
}

- (void)commit {
  [[UserProfile current] save];
  [self updateControls];
}

- (void)updateControls {
  self.dateOfBirthTextField.inputView = self.dateOfBirthPicker;

  if([[UserProfile current] dateOfBirth]) {
    self.dateOfBirthPicker.date = [[UserProfile current] dateOfBirth];
  }

  self.dateOfBirthTextField.text = [[[UserProfile current] dateOfBirth] classicDate];
  self.fullNameTextField.text = [UserProfile current].fullName;
}

- (void)dateOfBirthPickerChanged:(UIDatePicker *)sender {
  [UserProfile current].dateOfBirth = self.dateOfBirthPicker.date;
  [self commit];
}

# pragma mark - Closing text inputs
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];

  return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.dateOfBirthTextField resignFirstResponder];
  [self.fullNameTextField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  if(textField == self.fullNameTextField) {
    [UserProfile current].fullName = self.fullNameTextField.text;
  }

  [self commit];
}

# pragma mark - View Navigation

- (IBAction)letsChartTapped:(id)sender {
  [self textFieldShouldReturn:self.fullNameTextField];

  [self backOutToRootViewController];
}

- (IBAction)backTapped:(id)sender {
  [self textFieldShouldReturn:self.fullNameTextField];

  [self.navigationController popViewControllerAnimated:TRUE];
}

- (BOOL)shouldAutorotate {
  return FALSE;
}

@end
