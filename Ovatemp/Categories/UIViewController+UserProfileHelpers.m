//
//  UIViewController+UserProfileHelpers.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/19/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UIViewController+UserProfileHelpers.h"

@implementation UIViewController (UserProfileHelpers)

- (UIDatePicker *)useDatePickerForTextField:(UITextField *)textField {
  UIDatePicker *datePicker = [[UIDatePicker alloc] init];
  datePicker.datePickerMode = UIDatePickerModeDate;
  textField.inputView = datePicker;

  return datePicker;
}

@end
