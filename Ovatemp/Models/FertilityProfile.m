//
//  FertilityProfile.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/26/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "FertilityProfile.h"

@implementation FertilityProfile

- (id)init {
  self = [super init];
  if(!self) { return nil; }

  self.ignoredAttributes = [NSSet setWithArray:@[@"createdAt", @"updatedAt"]];

  return self;
}

@end
