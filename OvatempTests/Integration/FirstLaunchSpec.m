//
//  FirstLaunchSpec.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "KIFUITestActor+OTAdditions.h"

#import "SessionViewController.h"
#import "NSDate+Formatters.h"
#import "NSDate+CalendarOps.h"

SpecBegin(FirstLaunch)

describe(@"at first launch", ^{
  beforeAll(^{
    [tester logOut];
    [tester resetUsers];
  });

  it(@"should show a login or register screen", ^{
    expect(ACTIVE_VIEW_CONTROLLER).to.beKindOf([SessionViewController class]);
  });

  it(@"should show an onboarding wizard when registering", ^{
    [tester waitForViewWithAccessibilityLabel:@"Email"];

    [tester clearTextFromAndThenEnterText:@"test@example.com" intoViewWithAccessibilityLabel:@"Email"];
    [tester clearTextFromAndThenEnterText:@"password" intoViewWithAccessibilityLabel:@"Password"];
    [tester tapViewWithAccessibilityLabel:@"Sign Up"];

    [tester tapViewWithAccessibilityLabel:@"Trying to avoid"];
    UISwitch *conceive = (UISwitch *)[tester waitForViewWithAccessibilityLabel:@"Trying to conceive"];
    UISwitch *avoid = (UISwitch *)[tester waitForViewWithAccessibilityLabel:@"Trying to avoid"];

    expect(conceive.on).to.beFalsy;
    expect(avoid.on).to.beTruthy;

    [tester tapViewWithAccessibilityLabel:@"Trying to conceive"];
    expect(conceive.on).to.beTruthy;
    expect(avoid.on).to.beFalsy;


    NSDate *cycleDate = [[NSDate date] addDays:-2];
    NSLog(@"Cycle date %@", cycleDate);
    UITextField *dateField = (UITextField *)[tester enterDate:cycleDate intoDatePickerTextFieldWithAccessibilityLabel:@"Last Cycle Date"];

    expect(dateField.text).to.equal([cycleDate classicDate]);

    [tester tapViewWithAccessibilityLabel:@"Next Page"];
    [tester clearTextFromAndThenEnterText:@"John Testerman" intoViewWithAccessibilityLabel:@"Full name"];

    [tester tapViewWithAccessibilityLabel:@"Date of birth"];
    dateField = (UITextField *)[tester enterDate:[NSDate dateWithTimeIntervalSince1970:0] intoDatePickerTextFieldWithAccessibilityLabel:@"Date of birth"];
    expect(dateField.text).to.equal([[NSDate dateWithTimeIntervalSince1970:0] classicDate]);

    [tester tapViewWithAccessibilityLabel:@"Complete form"];
    [tester tapViewWithAccessibilityLabel:@"More"];
    UILabel *fullNameLabel = (UILabel *)[tester waitForViewWithAccessibilityLabel:@"Full name"];
    expect(fullNameLabel.text).to.equal(@"John Testerman");

    conceive = (UISwitch *)[tester waitForViewWithAccessibilityLabel:@"Trying to conceive"];
    avoid = (UISwitch *)[tester waitForViewWithAccessibilityLabel:@"Trying to avoid"];
    expect(conceive.on).to.beTruthy;
    expect(avoid.on).to.beFalsy;

    [tester tapViewWithAccessibilityLabel:@"Profile Settings"];
    dateField = (UITextField *)[tester waitForViewWithAccessibilityLabel:@"Date of birth"];
    expect(dateField.text).to.equal([[NSDate dateWithTimeIntervalSince1970:0] classicDate]);
    UITextField *fullNameTextField = (UITextField *)[tester waitForViewWithAccessibilityLabel:@"Full name"];
    expect(fullNameTextField.text).to.equal(@"John Testerman");

    [tester tapViewWithAccessibilityLabel:@"Today"];
    UILabel *cycleDayLabel = (UILabel *)[tester waitForViewWithAccessibilityLabel:@"Cycle Day"];
    // Because we set the first day of the cycle to be two days ago
    expect(cycleDayLabel.text).to.equal(@"Cycle Day: #3");
  });
});

SpecEnd