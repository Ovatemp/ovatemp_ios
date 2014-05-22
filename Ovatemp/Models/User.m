//
//  User.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "User.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <Mixpanel/Mixpanel.h>

static User *_currentUser;

@implementation User

+ (User *)current {
  return _currentUser;
}

+ (void)setCurrent:(User *)user {
  _currentUser = user;

  if (user.id && !user.id.isNull) {
    // Log user id in Google Analytics
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:@"&uid" value:user.id.stringValue];

    // Log user id in Mixpanel
    [[Mixpanel sharedInstance] registerSuperProperties:@{@"User ID": user.id.stringValue}];
  }
}

- (id)init {
  self = [super init];
  self.ignoredAttributes = [NSSet setWithArray:@[@"admin"]];
  return self;
}

@end
