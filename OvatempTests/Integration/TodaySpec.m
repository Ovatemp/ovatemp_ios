//
//  TodaySpec.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/25/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "KIFUITestActor+OTAdditions.h"
#import "AppDelegate.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"

SpecBegin(TodaySpec)

describe(@"Today screen", ^{
  context(@"with an existing cycle", ^{
    beforeAll(^{
      [tester registerUser];
      [tester tapViewWithAccessibilityLabel:@"Today"];
    });

    it(@"has a functioning temperature cell", ^{
      // Scroll to the right row
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Checklist"];

      UILabel *slideLabel = (UILabel*)[tester waitForViewWithAccessibilityLabel:@"Slide to edit temperature"];
      expect(slideLabel.text).to.equal(@"❮ slide to change");

      [tester setValue:99.5 forSliderWithAccessibilityLabel:@"Change Temperature"];

      [tester waitForTimeInterval:.5];

      // Sometimes the test scroller is off by a tenth of a degree, so just
      // skip that
      UILabel *temperatureLabel = (UILabel *)[tester waitForViewWithAccessibilityLabel:@"Temperature Value"];
      expect([temperatureLabel.text substringToIndex:3]).to.equal(@"99.");
      expect([temperatureLabel.text substringFromIndex:4]).to.equal(@"ºF");
    });

    it(@"has a functioning period cell", ^{
      // Scroll to the right row
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] inTableViewWithAccessibilityIdentifier:@"Checklist"];

      UILabel *slideLabel = (UILabel*)[tester waitForViewWithAccessibilityLabel:@"Slide to edit period"];
      expect(slideLabel.text).to.equal(@"❮ slide to change");

      [tester tapViewWithAccessibilityLabel:@"Period: Spotting" traits:UIAccessibilityTraitButton];

      UILabel *periodLabel = (UILabel *)[tester waitForViewWithAccessibilityLabel:@"Period"];
      expect(periodLabel.text).to.equal(@"Spotting");

      [tester tapViewWithAccessibilityLabel:@"Period: Spotting"];
      expect(periodLabel.text).to.beNil();
    });

    it(@"it saves when going to the calendar and coming back", ^{
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] inTableViewWithAccessibilityIdentifier:@"Checklist"];

      UILabel *periodLabel = (UILabel*)[tester waitForViewWithAccessibilityLabel:@"Period Selection"];
      expect(periodLabel.text).to.equal(@"Swipe to edit");

      [tester tapViewWithAccessibilityLabel:@"Period Spotting Button" traits:UIAccessibilityTraitButton];
      expect(periodLabel.text).to.equal(@"Spotting");

      [tester tapViewWithAccessibilityLabel:@"Go to Previous Day"];
      expect(periodLabel.text).to.equal(@"Swipe to edit");

      [tester tapViewWithAccessibilityLabel:@"Go to Next Day"];
      expect(periodLabel.text).to.equal(@"Spotting");
    });

    it(@"has a functioning cervical fluid/vaginal sensation cell", ^{
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] inTableViewWithAccessibilityIdentifier:@"Checklist"];

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
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] inTableViewWithAccessibilityIdentifier:@"Checklist"];
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] inTableViewWithAccessibilityIdentifier:@"Checklist"];

      UILabel *periodLabel = (UILabel*)[tester waitForViewWithAccessibilityLabel:@"Intercourse Selection"];
      expect(periodLabel.text).to.equal(@"Swipe to edit");

      [tester tapViewWithAccessibilityLabel:@"Intercourse Protected Button" traits:UIAccessibilityTraitButton];

      expect(periodLabel.text).to.equal(@"Protected");

      [tester tapViewWithAccessibilityLabel:@"Intercourse Protected Button"];

      expect(periodLabel.text).to.equal(@"Swipe to edit");
    });

    it(@"has a functioning symptoms/mood cell", ^{
      // Scroll to the right row
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] inTableViewWithAccessibilityIdentifier:@"Checklist"];

      UILabel *periodLabel = (UILabel*)[tester waitForViewWithAccessibilityLabel:@"Mood Selection"];
      expect(periodLabel.text).to.equal(@"Swipe to edit");

      [tester tapViewWithAccessibilityLabel:@"Mood Amazing Button" traits:UIAccessibilityTraitButton];

      expect(periodLabel.text).to.equal(@"Amazing");

      [tester tapViewWithAccessibilityLabel:@"Mood Amazing Button"];

      expect(periodLabel.text).to.equal(@"Swipe to edit");

      UITextView *symptomsTextView = (UITextView*)[tester waitForViewWithAccessibilityLabel:@"Symptoms Selection"];
      expect(symptomsTextView.text).to.equal(@"");

      [tester waitForAccessibilityElement:nil view:nil withIdentifier:@"Symptoms Options Page" tappable:NO];

      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Symptoms Options"];
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] inTableViewWithAccessibilityIdentifier:@"Symptoms Options"];

      [tester waitForTimeInterval:1];
      expect(symptomsTextView.text).to.equal(@"Bloating, Breast tenderness");
    });

    it(@"has a functioning supplements/medicine cell", ^{
      // Scroll to the right row
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] inTableViewWithAccessibilityIdentifier:@"Checklist"];

      UITextView *supplementsTextView = (UITextView*)[tester waitForViewWithAccessibilityLabel:@"Supplements Selection"];
      expect(supplementsTextView.text).to.equal(@"");

      UITextView *medicineTextView = (UITextView*)[tester waitForViewWithAccessibilityLabel:@"Medicine Selection"];
      expect(medicineTextView.text).to.equal(@"");

      [tester waitForAccessibilityElement:nil view:nil withIdentifier:@"Supplements Options Page" tappable:NO];
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Supplements Options"];
      [tester waitForAccessibilityElement:nil view:nil withIdentifier:@"Medicine Options Page" tappable:NO];
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] inTableViewWithAccessibilityIdentifier:@"Medicine Options"];

      [tester waitForTimeInterval:0.5];
      expect(supplementsTextView.text).to.equal(@"Calcium");
      expect(medicineTextView.text).to.equal(@"Albuterol");
    });

    it(@"has a functioning secondary signs cell", ^{
      // Scroll to the right row
      [tester tapRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] inTableViewWithAccessibilityIdentifier:@"Checklist"];

      [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Ovulation Prediction Kit Selection"];
      [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Ferning Selection"];

      [tester tapViewWithAccessibilityLabel:@"Ovulation Prediction Kit Positive"];
      [tester tapViewWithAccessibilityLabel:@"Ferning Positive"];

      UIImageView *opkImageView = (UIImageView*)[tester waitForViewWithAccessibilityLabel:@"Ovulation Prediction Kit Selection"];
      UIImageView *ferningImageView = (UIImageView*)[tester waitForViewWithAccessibilityLabel:@"Ferning Selection"];

      expect(opkImageView.accessibilityValue).to.equal(@"Ovulation Prediction Kit Positive");
      expect(ferningImageView.accessibilityValue).to.equal(@"Ferning Positive");
    });

    it(@"returns to today when the Today button is tapped in the navigation bar", ^{
      [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Go to Next Day"];

      [tester tapViewWithAccessibilityLabel:@"Go to Previous Day"];
      [tester waitForViewWithAccessibilityLabel:@"Go to Next Day"];

      [tester tapViewWithAccessibilityLabel:@"Go to Previous Day"];
      [tester waitForViewWithAccessibilityLabel:@"Go to Next Day"];
      [tester tapViewWithAccessibilityLabel:@"Go to Previous Day"];
      [tester waitForViewWithAccessibilityLabel:@"Go to Next Day"];

      [tester tapViewWithAccessibilityLabel:@"Today"];
      [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Go to Next Day"];
      [tester tapViewWithAccessibilityLabel:@"Go to Previous Day"];
      [tester waitForViewWithAccessibilityLabel:@"Go to Next Day"];
      [tester tapViewWithAccessibilityLabel:@"Today"];
      [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Go to Next Day"];
    });
  });
});

SpecEnd