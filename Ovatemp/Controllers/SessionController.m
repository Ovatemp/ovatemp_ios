//
//  SessionController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SessionController.h"
#import "ConnectionManager.h"
#import "User.h"
#import "Configuration.h"
#import "Day.h"
#import "Supplement.h"
#import "Medicine.h"
#import "Symptom.h"

@implementation SessionController

+ (void)loggedInWithUser:(NSDictionary *)userDict andToken:(NSString *)token {
  User *user = [User withAttributes:userDict];
  [User setCurrent:user];
  [Configuration sharedConfiguration].token = token;
}

+ (void)refreshToken {
  [ConnectionManager put:@"/sessions/refresh"
                  params:nil
                  target:self
                 success:@selector(loadSupplementsEtc:)
                 failure:@selector(presentError:)
   ];
}

+ (void)logOut {
  [User setCurrent:nil];
  [Configuration sharedConfiguration].token = nil;
  [Day resetInstances];
}

+ (void)presentError:(NSError *)error {
  NSLog(@"couldn't refresh token: %@", error);
}

+ (void)loadSupplementsEtc:(NSDictionary *)response {
  [Supplement resetInstancesWithArray:response[@"supplements"]];
  [Medicine resetInstancesWithArray:response[@"medicines"]];
  [Symptom resetInstancesWithArray:response[@"symptoms"]];
}

@end