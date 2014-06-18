//
//  Subscription.m
//  Ovatemp
//
//  Created by Jason Welch on 9/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Subscription.h"
#import "Alert.h"
#import "SubscriptionHelper.h"
#import "User.h"

static Subscription *_currentSubscription;

@implementation Subscription

+ (Subscription *)current {
  if (!_currentSubscription) {
    _currentSubscription = [Subscription withAttributes:@{
                                                        @"name": @"",
                                                        @"expires_at": [NSNull null],
                                                        }];
  }
  return _currentSubscription;
}

+ (void)setCurrent:(Subscription *)subscription {
  _currentSubscription = subscription;
}


- (void)save {
  NSLog(@"%@", [self attributesCamelCased:FALSE]);
  [ConnectionManager put:@"/subscription"
                  params:@{@"subscription": [self attributesCamelCased:FALSE]}
                 success:^(NSDictionary *response) {
                   self.attributes = response[@"subscription"];
                   NSLog(@"Saved. That means that the remote user has an expiration date of %@", [Subscription current].expiresAt);
                 }
                 failure:^(NSError *error) {
                   [Alert presentError:error];
                 }];
}

// For testing purposes
- (void) printDetails {

  NSString *printOut = [NSString stringWithFormat:@"\nSubscription Name: %@\nExpires: %@\n\n", _name, _expiresAt];
  NSLog(@"%@", printOut);
}

@end
