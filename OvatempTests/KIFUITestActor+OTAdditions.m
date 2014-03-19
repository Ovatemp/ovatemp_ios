//
//  KIFUITestActor+OTAdditions.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/19/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "KIFUITestActor+OTAdditions.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "SessionViewController.h"
#import "ConnectionManager.h"
#import "OvatempTestHelpers.h"
#import "NSDate+CalendarOps.h"

@implementation KIFUITestActor (OTAdditions)

- (void)resetUsers {
  [ConnectionManager post:@"/test_actions/reset_users"
                   params:@{}
                  success:^(NSDictionary *response) { NSLog(@"reset server's users"); }
                  failure:^(NSError *error) { NSLog(@"couldn't reset server's users"); }];
}

- (void)registerUser {
  if (![ACTIVE_VIEW_CONTROLLER isKindOfClass:[SessionViewController class]]) {
    [self logOut];
  }
  [self resetUsers];
  [self waitForViewWithAccessibilityLabel:@"Email"];

  [self clearTextFromAndThenEnterText:@"test@example.com" intoViewWithAccessibilityLabel:@"Email"];
  [self clearTextFromAndThenEnterText:@"password" intoViewWithAccessibilityLabel:@"Password"];
  [self tapViewWithAccessibilityLabel:@"Sign Up"];

  NSDate *cycleDate = [[NSDate date] addDays:-2];
  [tester enterDate:cycleDate intoDatePickerTextFieldWithAccessibilityLabel:@"Last Cycle Date"];

  [self tapViewWithAccessibilityLabel:@"Next Page"];
  [self tapViewWithAccessibilityLabel:@"Complete form"];

  [self waitForViewWithAccessibilityLabel:@"More"];
}

- (void)logOut {
  if (![ACTIVE_VIEW_CONTROLLER isKindOfClass:[SessionViewController class]]) {
    NSLog(@"Logging out because %@ is not a SessionViewController", ACTIVE_VIEW_CONTROLLER);
    // Navigate to the "More" tab

    [self waitForViewWithAccessibilityLabel:@"More"];
    [self tapViewWithAccessibilityLabel:@"More"];
    // Make sure we get to the root of the navigation controller
    [self tapViewWithAccessibilityLabel:@"More"];

    // Log the user out
    [self waitForViewWithAccessibilityLabel:@"Log Out Button"];
    [self tapViewWithAccessibilityLabel:@"Log Out Button"];
  }
  [self waitForViewWithAccessibilityLabel:@"Email"];
  
}

- (UITextField *)enterDate:(NSDate*)date intoDatePickerTextFieldWithAccessibilityLabel:(NSString*)label
{
  UITextField *textField =  (UITextField*)[tester waitForViewWithAccessibilityLabel:label];

  UIDatePicker *picker = (UIDatePicker *)textField.inputView;
  [picker setDate:date animated:YES];
  [picker sendActionsForControlEvents:UIControlEventValueChanged];

  return textField;
}

@end
