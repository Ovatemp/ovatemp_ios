//
//  Question.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/26/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Question.h"

@implementation Question

- (id)init {
  self = [super init];
  if(!self) { return nil; }


  NSMutableSet *ignore = [[NSMutableSet alloc] init];

  NSString *fertilityProfiles = @"energize hydrate category nourish position refresh ventilate revitalize activate";
  for(NSString *name in [fertilityProfiles componentsSeparatedByString:@" "]) {
    [ignore addObject:[name stringByAppendingString:@"Yes"]];
    [ignore addObject:[name stringByAppendingString:@"No"]];
  }

  [ignore addObjectsFromArray:[@"createdAt updatedAt category position" componentsSeparatedByString:@" "]];

  self.ignoredAttributes = [ignore copy];

  return self;
}

- (void)answer:(BOOL)yes success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {
  [ConnectionManager post:@"/answers"
                   params:@{@"answer":
                            @{
                              @"question_id": self.id,
                              @"response": [NSNumber numberWithBool:yes],
                            }
                   }
                   success:onSuccess
                  failure:onFailure];
}

@end