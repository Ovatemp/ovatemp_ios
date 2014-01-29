//
//  FirstLaunchSpec.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "OvatempTestHelpers.h"

SpecBegin(FirstLaunch)

describe(@"at first launch", ^{
  it(@"should show a login or register screen", ^{
    [tester waitForViewWithAccessibilityLabel:@"Register View"];
//    expect(activeViewController).to.beKindOf(
  });
});

SpecEnd