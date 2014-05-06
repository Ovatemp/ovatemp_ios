//
//  SessionSpec.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/3/14..
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "KIFUITestActor+OTAdditions.h"
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
      [tester registerUser];
      [tester tapViewWithAccessibilityLabel:@"Today"];
    });

    fit(@"should kick you out if your token becomes invalid and you make a request", ^{
      [tester resetUsers];

//      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Checklist"];
//      [tester tapViewWithAccessibilityLabel:@"Set Temperature" traits:UIAccessibilityTraitButton];

      [tester tapViewWithAccessibilityLabel:@"Go to Previous Day"];

      // Wait for the error message to appear
      [tester waitForViewWithAccessibilityLabel:@"Okay"];
      [tester tapViewWithAccessibilityLabel:@"Okay"];

      [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Go to Previous Day"];

      expect(ACTIVE_VIEW_CONTROLLER).to.beKindOf([SessionViewController class]);
    });

    it(@"should allow you to reset your password", ^{
      [tester logOut];

      // This should match the registration email
      [tester enterText:@"test@example.com" intoViewWithAccessibilityLabel:@"Email"];
      [tester tapViewWithAccessibilityLabel:@"Forgot Password"];
      // Confirm
      [tester tapViewWithAccessibilityLabel:@"Reset password"];


      Alert *alert = (Alert *)[tester waitForViewWithAccessibilityLabel:@"Alert Message"];
      NSString *message = alert.accessibilityValue;
      expect([message hasPrefix:@"Please check your email"]).to.beTruthy;
      [tester tapViewWithAccessibilityLabel:@"OK"];

      // This should NOT match the registration email
      [tester clearTextFromAndThenEnterText:@"INCORRECT@example.com" intoViewWithAccessibilityLabel:@"Email"];
      [tester tapViewWithAccessibilityLabel:@"Forgot Password"];
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