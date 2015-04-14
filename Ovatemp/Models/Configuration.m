//
//  Configuration.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/29/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Configuration.h"
#import "User.h"
#import "Day.h"
#import "FertilityProfile.h"

static Configuration *_sharedConfiguration;

@implementation Configuration

# pragma mark - Setup

+ (Configuration *)sharedConfiguration {
  if (!_sharedConfiguration) {
    _sharedConfiguration = [[self alloc] init];
    [_sharedConfiguration observeKeys:@[@"token", @"hasSeenProfileIntroScreen", @"coachingContentUrls"]];
  }
  return _sharedConfiguration;
}

# pragma mark - KVO

- (void)observeKeys:(NSArray *)keys {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  for (NSString *key in keys) {
    id value = [userDefaults objectForKey:key];
    [self setValue:value forKey:key];
    [self addObserver:self forKeyPath:key options:0 context:nil];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  id value = [self valueForKey:keyPath];
  [userDefaults setObject:value forKey:keyPath];
  [userDefaults synchronize];
}

# pragma mark - Session management

+ (void)loggedInWithResponse:(NSDictionary *)response
{
  NSDictionary *userDict = response[@"user"];
  User *user = [User withAttributes:userDict];
  [User setCurrent:user];

  [Configuration sharedConfiguration].token = response[@"token"];
  if (![response[@"user_profile"] isNull]) {
    [UserProfile setCurrent:[UserProfile withAttributes:response[@"user_profile"]]];
    NSLog(@"User Profile? %@", [UserProfile withAttributes:response[@"user_profile"]]);
  } else {
    [UserProfile setCurrent:nil];
  }
  if (![response[@"subscription"] isNull]) {
    [Subscription setCurrent:[Subscription withAttributes:response[@"subscription"]]];
  } else {
    [Subscription setCurrent:nil];
  }

  [Supplement resetInstancesWithArray:response[@"supplements"]];
  [Medicine resetInstancesWithArray:response[@"medicines"]];
  [Symptom resetInstancesWithArray:response[@"symptoms"]];

  [Day resetInstances];

  if (user.fertilityProfileId && !user.fertilityProfileId.isNull) {
    [FertilityProfile loadAll];
  }
}

+ (BOOL)loggedIn {
  return [Configuration sharedConfiguration].token != nil;
}

+ (void)logOut {
  [User setCurrent:nil];
  [UserProfile setCurrent:nil];
  [Day resetInstances];
  [User resetInstances];
  [UserProfile resetInstances];
  [Configuration sharedConfiguration].token = nil;
  [Configuration sharedConfiguration].coachingContentUrls = nil;
  [Configuration sharedConfiguration].hasSeenProfileIntroScreen = @NO;
}


@end
