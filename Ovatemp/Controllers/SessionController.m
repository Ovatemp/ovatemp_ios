//
//  SessionController.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SessionController.h"
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

+ (void)logOut {
  [User setCurrent:nil];
  [Configuration sharedConfiguration].token = nil;
  [Day resetInstances];
}

+ (void)loadSupplementsEtc:(NSDictionary *)response {
  NSLog(@"loading supplements from response: %@", response);
  [Supplement resetInstancesWithArray:response[@"supplements"]];
  [Medicine resetInstancesWithArray:response[@"medicines"]];
  [Symptom resetInstancesWithArray:response[@"symptoms"]];
}

@end