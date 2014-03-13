//
//  Cycle.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Cycle.h"

@interface Cycle () {
  Day *_day;
}
@end

@implementation Cycle

- (Cycle *)initWithDay:(Day *)day {
  // Download from the server
  self = [super init];
  if(!self) { return nil; }

  _day = day;
  // create all the days and have them update from the server

  return self;
}

+ (void)loadDate:(NSDate *)date success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {
  [ConnectionManager get:@"/cycles"
                  params:@{
                           @"date": [date dateId],
                           }
                 success:^(NSDictionary *response) {
                   NSArray *days = response[@"days"];
                   [Cycle cycleFromDaysArray:days];
                   
                   if(onSuccess) onSuccess(response);
                 }
                 failure:^(NSError *error) {
                   if(error)
                   NSLog(@"cycle failure: %@", error);

                   if(onFailure) onFailure(error);
                 }];
}

+ (Cycle *)cycleFromDaysArray:(NSArray *)daysResponse {
  Cycle *cycle = [[Cycle alloc] init];

  NSMutableArray *days = [[NSMutableArray alloc] initWithCapacity:daysResponse.count];

  Day *day;
  for(NSDictionary *dayAttrs in daysResponse) {
    day = [Day withAttributes:dayAttrs];
    day.cycle = cycle;
    [days addObject:day];
  }

  cycle.days = [days sortedArrayUsingComparator:^(Day* day1, Day* day2) {
    return [day1.date compare:day2.date];
  }];

  return cycle;
}

- (Cycle *)previousCycle {
  if(!_day) {
    return nil;
  }

  return [[Cycle alloc] initWithDay:[_day previousDay]];
}

- (Cycle *)nextCycle {
  if(!_day) {
    return nil;
  }

  return [[Cycle alloc] initWithDay:[[self.days lastObject] nextDay]];
}

@end
