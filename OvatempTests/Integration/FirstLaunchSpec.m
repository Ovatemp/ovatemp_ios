//
//  FirstLaunchSpec.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "OvatempTestHelpers.h"

#import "SessionViewController.h"

SpecBegin(FirstLaunch)

describe(@"at first launch", ^{
  it(@"should show a login or register screen", ^{
    [tester waitForViewWithAccessibilityLabel:@"Session Instructions"];
    expect(activeViewController).to.beKindOf([SessionViewController class]);
  });
});

SpecEnd