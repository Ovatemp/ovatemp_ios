//
//  UserProfile.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UserProfile.h"

static UserProfile *_currentUserProfile;

@implementation UserProfile

+ (UserProfile *)current {
  if (!_currentUserProfile) {
    _currentUserProfile = [UserProfile withAttributes:@{
                                                        @"full_name": @"",
                                                        @"date_of_birth": [NSNull null],
                                                        @"trying_to_conceive": @YES,
                                                        @"five_day_rule": [NSNull null],
                                                        @"dry_day_rule": [NSNull null],
                                                        @"temperature_shift_rule": [NSNull null],
                                                        @"peak_day_rule": [NSNull null]
                                                        }];
  }
  return _currentUserProfile;
}

+ (void)setCurrent:(UserProfile *)userProfile {
  _currentUserProfile = userProfile;
}

- (id)init {
  self = [super init];
  if(!self) { return nil; }

  self.ignoredAttributes = [NSSet setWithArray:@[@"createdAt", @"updatedAt", @"userId"]];

  return self;
}

- (void)refresh:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {
  [ConnectionManager get:@"/user_profiles"
                  params:@{}
                 success:^(NSDictionary *response) {
                   self.attributes = response[@"user_profile"];

                   if(onSuccess) onSuccess(response);
                 }
                 failure:^(NSError *error) {
                   // HANDLEERROR
                   if(onFailure) onFailure(error);
                 }];
}

- (void)save {
    [ConnectionManager put:@"/user_profiles"
                    params:@{@"user_profile": [self attributesCamelCased:FALSE]}
                   success:^(NSDictionary *response) {
                     self.attributes = response[@"user_profile"];
                   }
                   failure:^(NSError *error) {
                     // HANDLEERROR
                     NSLog(@"couldn't save");
                   }];
}
@end