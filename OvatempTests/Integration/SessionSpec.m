//
//  SessionSpec.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/3/14..
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "OvatempTestHelpers.h"
#import "AppDelegate.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "Configuration.h"
#import "SessionViewController.h"
#import "Alert.h"

SpecBegin(SessionSpec)

describe(@"Authentication failures", ^{
  context(@"Logged in", ^{
    beforeEach(^{
      [self registerUser];
      [tester tapViewWithAccessibilityLabel:@"Today"];
    });

    it(@"should kick you out if your token becomes invalid and you make a request", ^{
      [self resetUsers];

      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Checklist"];
      [tester tapViewWithAccessibilityLabel:@"Set Temperature" traits:UIAccessibilityTraitButton];

      [tester tapViewWithAccessibilityLabel:@"Go to Previous Day"];
      [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Go to Previous Day"];

      [tester tapViewWithAccessibilityLabel:@"OK"];

      expect(ACTIVE_VIEW_CONTROLLER).to.beKindOf([SessionViewController class]);
    });

    it(@"should allow you to reset your password", ^{
      [self logOut];

      // This should match the registration email
      [tester enterText:@"test@example.com" intoViewWithAccessibilityLabel:@"Email Field"];
      [tester tapViewWithAccessibilityLabel:@"Reset Password"];
      // Confirm
      [tester tapViewWithAccessibilityLabel:@"Reset password"];


      Alert *alert = (Alert *)[tester waitForViewWithAccessibilityLabel:@"Alert Message"];
      NSString *message = alert.accessibilityValue;
      expect([message hasPrefix:@"Please check your email"]).to.beTruthy;
      [tester tapViewWithAccessibilityLabel:@"OK"];

      // This should NOT match the registration email
      [tester clearTextFromAndThenEnterText:@"INCORRECT@example.com" intoViewWithAccessibilityLabel:@"Email Field"];
      [tester tapViewWithAccessibilityLabel:@"Reset Password"];
      // Confirm
      [tester tapViewWithAccessibilityLabel:@"Reset password"];

      alert = (Alert *)[tester waitForViewWithAccessibilityLabel:@"Alert Message"];
      message = alert.accessibilityValue;
      expect([message hasPrefix:@"Sorry, we couldn't reset your password"]).to.beTruthy;

      [tester tapViewWithAccessibilityLabel:@"OK"];
    });
  });
});

SpecEnd