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

  UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
  [doneToolbar sizeToFit];
  UIBarButtonItem *flexArea = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self.view action:@selector(endEditing:)];
  doneToolbar.items = @[flexArea, doneButton];
  textField.inputAccessoryView = doneToolbar;

  return datePicker;
}

@end
