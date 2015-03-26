//
//  User.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "User.h"
#import "UserProfile.h"

static User *_currentUser;

@implementation User

+ (User *)current {
  return _currentUser;
}

+ (void)setCurrent:(User *)user {
  _currentUser = user;

  if (user.id && !user.id.isNull) {
    
    NSMutableDictionary *profileProperties = [NSMutableDictionary dictionaryWithCapacity:5];
    profileProperties[@"User ID"] = user.id.stringValue;

    UserProfile *profile = [UserProfile current];
    if (profile.fullName) {
      profileProperties[@"Name"] = profile.fullName;
    }

    if (user.createdAt) {
      profileProperties[@"Signed Up"] = user.createdAt.dateId;
    }

    if (user.email) {
      profileProperties[@"Email"] = user.email;
    }

    if (profile.dateOfBirth) {
      NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                         components:NSCalendarUnitYear
                                         fromDate:profile.dateOfBirth
                                         toDate:[NSDate date]
                                         options:0];
      NSInteger age = [ageComponents year];
      profileProperties[@"Age"] = @(age).stringValue;
    }

  }
}

- (id)init {
  self = [super init];
  self.ignoredAttributes = [NSSet setWithArray:@[@"admin"]];
  return self;
}

- (void)setProfile:(UserProfile *)profile {
  [UserProfile setCurrent:profile];
}

- (UserProfile *)profile {
  return [UserProfile current];
}

@end
