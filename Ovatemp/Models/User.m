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

    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel identify:user.id.stringValue];

    NSMutableDictionary *profileProperties = [NSMutableDictionary dictionaryWithCapacity:5];
    profileProperties[@"User ID"] = user.id.stringValue;

    if (user.profile.fullName) {
      profileProperties[@"Name"] = user.profile.fullName;
    }

    if (user.createdAt) {
      profileProperties[@"Signed Up"] = user.createdAt.dateId;
    }

    if (user.email) {
      profileProperties[@"Email"] = user.email;
    }

    if (user.profile.dateOfBirth) {
      NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                         components:NSYearCalendarUnit
                                         fromDate:user.profile.dateOfBirth
                                         toDate:[NSDate date]
                                         options:0];
      NSInteger age = [ageComponents year];
      profileProperties[@"Age"] = @(age).stringValue;
    }

    if (profileProperties.count) {
      [mixpanel.people set:profileProperties];
    }
  }
}

- (id)init {
  self = [super init];
  self.ignoredAttributes = [NSSet setWithArray:@[@"admin"]];
  return self;
}

@end
