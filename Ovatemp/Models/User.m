//
//  User.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "User.h"

static User *_currentUser;

@implementation User

+ (User *)current {
  return _currentUser;
}

+ (void)setCurrent:(User *)user {
  _currentUser = user;
}

- (id)init {
  self = [super init];
  self.ignoredAttributes = [NSSet setWithArray:@[@"admin"]];
  return self;
}

@end
