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

SpecBegin(SessionSpec)

describe(@"Authentication failures", ^{
  context(@"Logged in", ^{
    beforeEach(^{
      [self logIn];
      [tester tapViewWithAccessibilityLabel:@"Today"];
    });

    it(@"should kick you out if your token changes", ^{
      [Configuration sharedConfiguration].token = @"BOGUS";

      [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Go to Previous Day"];

      expect(ACTIVE_VIEW_CONTROLLER).to.beKindOf([SessionViewController class]);
    });

    it(@"should kick you out if your token becomes invalid and you make a request", ^{
      [self resetUsers];
      [tester tapViewWithAccessibilityLabel:@"Go to Previous Day"];
      [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Go to Previous Day"];

      [tester tapViewWithAccessibilityLabel:@"OK"];

      expect(ACTIVE_VIEW_CONTROLLER).to.beKindOf([SessionViewController class]);
    });
  });
});

SpecEnd