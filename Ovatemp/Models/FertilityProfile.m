//
//  FertilityProfile.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/23/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "FertilityProfile.h"

#import "User.h"

@implementation FertilityProfile

+ (void)loadAll {
  [self loadAndThen:nil failure:nil];
}

+ (void)loadAndThen:(ConnectionManagerSuccess)success failure:(ConnectionManagerFailure)failure {
  [ConnectionManager get:@"/fertility_profiles" success:^(id response) {
    NSString *fertility_profile_name = response[@"fertility_profile_name"];
    if (fertility_profile_name) {
      [User current].fertilityProfileName = fertility_profile_name;
      NSDictionary *coaching_content_urls = response[@"coaching_content_urls"];
      if (coaching_content_urls) {
        [Configuration sharedConfiguration].coachingContentUrls = coaching_content_urls;
      }
    } else {
      NSLog(@"No fertility profile");
      [User current].fertilityProfileName = nil;
    }
    if (success) {
      success(response);
    }
  } failure:^(NSError *error) {
    if (failure) {
      failure(error);
    }
  }];
}

@end
