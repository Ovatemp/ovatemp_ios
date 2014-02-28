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
  beforeAll(^{
    [self logOut];
  });

  it(@"should show a login or register screen", ^{
    expect(ACTIVE_VIEW_CONTROLLER).to.beKindOf([SessionViewController class]);
  });
});

SpecEnd