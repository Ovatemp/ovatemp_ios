//
//  TodaySpec.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/25/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "OvatempTestHelpers.h"
#import "AppDelegate.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"

SpecBegin(TodaySpec)

describe(@"Today screen", ^{
  context(@"Logged in", ^{
    beforeAll(^{
      [self logIn];
      [tester tapViewWithAccessibilityLabel:@"Today"];
    });

    it(@"has a functioning period cell", ^{
      // Scroll to the right row
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] inTableViewWithAccessibilityIdentifier:@"Checklist"];

      UILabel *periodLabel = (UILabel*)[tester waitForViewWithAccessibilityLabel:@"Period Selection"];
      expect(periodLabel.text).to.equal(@"Swipe to edit");

      [tester tapViewWithAccessibilityLabel:@"Period Spotting Button" traits:UIAccessibilityTraitButton];

      expect(periodLabel.text).to.equal(@"Spotting");

      [tester tapViewWithAccessibilityLabel:@"Period Spotting Button"];

      expect(periodLabel.text).to.equal(@"Swipe to edit");
    });


    it(@"has a functioning cervical fluid/vaginal sensation cell", ^{
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] inTableViewWithAccessibilityIdentifier:@"Checklist"];

      UILabel *cervicalLabel = (UILabel*)[tester waitForViewWithAccessibilityLabel:@"Cervical Fluid Selection"];
      expect(cervicalLabel.text).to.equal(@"Swipe to edit");
      UILabel *vaginalLabel = (UILabel*)[tester waitForViewWithAccessibilityLabel:@"Vaginal Sensation Selection"];
      expect(vaginalLabel.text).to.equal(@"Swipe to edit");

      [tester waitForViewWithAccessibilityLabel:@"Cervical Fluid Creamy Button"];
      [tester tapViewWithAccessibilityLabel:@"Cervical Fluid Creamy Button"];

      [tester waitForViewWithAccessibilityLabel:@"Vaginal Sensation Lube Button"];
      [tester tapViewWithAccessibilityLabel:@"Vaginal Sensation Lube Button"];

      expect(cervicalLabel.text).to.equal(@"Creamy");
      expect(vaginalLabel.text).to.equal(@"Lube");

      [tester tapViewWithAccessibilityLabel:@"Vaginal Sensation Lube Button"];

      [tester waitForViewWithAccessibilityLabel:@"Cervical Fluid Creamy Button"];
      [tester tapViewWithAccessibilityLabel:@"Cervical Fluid Creamy Button"];

      expect(cervicalLabel.text).to.equal(@"Swipe to edit");
      expect(vaginalLabel.text).to.equal(@"Swipe to edit");
    });

    it(@"has a functioning intercourse cell", ^{
      // Scroll to the right row
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1] inTableViewWithAccessibilityIdentifier:@"Checklist"];

      UILabel *periodLabel = (UILabel*)[tester waitForViewWithAccessibilityLabel:@"Intercourse Selection"];
      expect(periodLabel.text).to.equal(@"Swipe to edit");

      [tester tapViewWithAccessibilityLabel:@"Intercourse Protected Button" traits:UIAccessibilityTraitButton];

      expect(periodLabel.text).to.equal(@"Protected");

      [tester tapViewWithAccessibilityLabel:@"Intercourse Protected Button"];

      expect(periodLabel.text).to.equal(@"Swipe to edit");
    });

    it(@"has a functioning symptoms/mood cell", ^{
      // Scroll to the right row
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1] inTableViewWithAccessibilityIdentifier:@"Checklist"];

      UILabel *periodLabel = (UILabel*)[tester waitForViewWithAccessibilityLabel:@"Mood Selection"];
      expect(periodLabel.text).to.equal(@"Swipe to edit");

      [tester tapViewWithAccessibilityLabel:@"Mood Amazing Button" traits:UIAccessibilityTraitButton];

      expect(periodLabel.text).to.equal(@"Amazing");

      [tester tapViewWithAccessibilityLabel:@"Mood Amazing Button"];

      expect(periodLabel.text).to.equal(@"Swipe to edit");
    });
  });
});

SpecEnd