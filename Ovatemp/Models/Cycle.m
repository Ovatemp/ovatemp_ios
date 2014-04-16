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

  return self;
}

- (void)loadDatesAndOnSuccess:(CycleDateLoadSuccess)onSuccess failure:(CycleDateLoadFailure)onFailure {
  [ConnectionManager get:@"/cycles"
                  params:@{
                           @"date": [[_day date] dateId],
                           }
                 success:^(NSDictionary *response) {
                   [Day resetInstances];
                   [self loadFromResponse: response];
                   if(onSuccess) onSuccess();
                 }
                 failure:^(NSError *error) {
                   if(onFailure) onFailure(error);
                 }];
}

+ (void)loadDate:(NSDate *)date success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {
  [ConnectionManager get:@"/cycles"
                  params:@{
                           @"date": [date dateId],
                           }
                 success:^(NSDictionary *response) {
                   [Day resetInstances];

                   [Cycle cycleFromResponse:response];

                   if(onSuccess) onSuccess(response);
                 }
                 failure:^(NSError *error) {
                  // HANDLEERROR

                   if(onFailure) onFailure(error);
                 }];
}


+ (void)loadDatesFrom:(NSDate *)startDate to:(NSDate *)endDate success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {
  [ConnectionManager get:@"/days"
                  params:@{
                           @"start_date": [startDate dateId],
                           @"end_date": [endDate dateId]
                           }
                 success:^(NSDictionary *response) {
                   [Day resetInstances];

                   NSArray *orphanDays = response[@"days"];
                   NSArray *cycles = response[@"cycles"];

                   if(orphanDays) {
                     for(NSDictionary *dayResponse in orphanDays) {
                       [Day withAttributes:dayResponse];
                     }
                   }

                   if(cycles) {
                     for(NSDictionary *cycleResponse in cycles) {
                       [Cycle cycleFromResponse:cycleResponse];
                     }
                   }

                   if(onSuccess) onSuccess(response);
                 }
                 failure:onFailure];
}

- (void)loadFromResponse:(NSDictionary *)cycleResponse {
  NSArray *daysResponse = cycleResponse[@"days"];
  
  NSMutableArray *days = [[NSMutableArray alloc] initWithCapacity:daysResponse.count];
  
  Day *day;
  for(NSDictionary *dayAttrs in daysResponse) {
    day = [Day withAttributes:dayAttrs];
    
    day.cycle = self;
    [days addObject:day];
  }
  
  self.days = [days sortedArrayUsingComparator:^(Day* day1, Day* day2) {
    return [day1.date compare:day2.date];
  }];
  
  if([cycleResponse[@"coverline"] isEqual:[NSNull null]]) {
    self.coverline = nil;
  } else {
    self.coverline = cycleResponse[@"coverline"];
  }
}

+ (Cycle *)cycleFromResponse:(NSDictionary *)cycleResponse {
  Cycle *cycle = [[Cycle alloc] init];
  NSArray *daysResponse = cycleResponse[@"days"];
  
  if(!daysResponse) {
    if(!cycleResponse[@"day"]) {
      NSLog(@"no day or days in: %@", cycleResponse);
    }
    
    [Day withAttributes:cycleResponse[@"day"]];
    
    return nil;
  }
  
  [cycle loadFromResponse: cycleResponse];

  return cycle;
}

- (NSString *)rangeString {
  if([self.days count] == 0) {return @"";}
  
  Day *firstDay = [self.days firstObject];
  Day *lastDay = [self.days lastObject];

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

  NSMutableString *rangeString = [[NSMutableString alloc] init];
  [rangeString appendString: [dateFormatter stringFromDate: firstDay.date]];
  [rangeString appendString: @" to "];
  [rangeString appendString: [dateFormatter stringFromDate: lastDay.date]];

  return rangeString;
}

- (Cycle *)previousCycle {
  if(!_day && [self.days count] == 0) {
    return nil;
  }

  Day *previousDay = [[self.days firstObject] previousDay];
  return [[Cycle alloc] initWithDay:previousDay];
}

- (Cycle *)nextCycle {
  if(!_day && [self.days count] == 0) {
    return nil;
  }
  
  Day *nextDay = [[self.days lastObject] nextDay];
  return [[Cycle alloc] initWithDay: nextDay];
}

@end
