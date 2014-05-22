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

static NSMutableArray *kAllCycles;
static BOOL kFullyLoaded;
static NSDate *kFirstDate;
static NSDate *kLastDate;
static NSInteger kTotalDays;

@implementation Cycle

- (NSString *)description {
  return [NSString stringWithFormat:@"Cycle %@ - %@", self.startDate.dateId, self.endDate.dateId];
}

+ (void)initialize {
  [super initialize];
  [self calculateDates];
}

+ (NSArray *)all {
  if (kAllCycles) {
    return [kAllCycles sortedArrayUsingComparator:^NSComparisonResult(Cycle *cycle1, Cycle *cycle2) {
      return [cycle1.startDate compare:cycle2.startDate];
    }];
  } else {
    return @[];
  }
}

+ (Cycle *)atIndex:(NSInteger)index {
  NSArray *allCycles = [Cycle all];
  if (index >= 0 && index < allCycles.count) {
    return [allCycles objectAtIndex:index];
  }
  return nil;
}

+ (void)calculateDates {
  NSDate *today = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:today];

  // Go to the end of two months from now
  [comps setMonth:[comps month]+2];
  [comps setDay:0];
  kLastDate = [calendar dateFromComponents:comps];

  [comps setMonth:0];
  [comps setDay:0];
  [comps setYear:comps.year - 2];
  kFirstDate = [calendar dateFromComponents:comps];

  kTotalDays = [[calendar components:NSDayCalendarUnit
                            fromDate:kFirstDate
                              toDate:kLastDate
                             options:0] day];
}

+ (NSDate *)firstDate {
  NSDate *firstDate = [[self all].firstObject startDate];
  if ([firstDate earlierDate:kFirstDate] == kFirstDate) {
    firstDate = kFirstDate;
  }

  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:firstDate];

  while (components.weekday != 1) {
    firstDate = [firstDate dateByAddingTimeInterval:60 * 60 * -24];
    components = [calendar components:NSWeekdayCalendarUnit fromDate:firstDate];
  }

  return firstDate;
}

+ (NSDate *)lastDate {
  return kLastDate;
}

+ (NSInteger)totalDays {
  return kTotalDays;
}

+ (BOOL)fullyLoaded {
  if (!isnormal(kFullyLoaded)) {
    kFullyLoaded = NO;
  }
  return kFullyLoaded;
}

+ (void)loadAllAnd:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {
  [ConnectionManager get:@"/days"
                  params:@{
                           @"start_date": [kFirstDate dateId],
                           @"end_date": [kLastDate dateId]
                           }
                 success:^(NSDictionary *response) {
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

                   kFullyLoaded = YES;
                   if(onSuccess) onSuccess(response);
                 }
                 failure:onFailure];
}

+ (void)loadDate:(NSDate *)date success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure {
  [ConnectionManager get:@"/cycles"
                  params:@{
                           @"date": [date dateId],
                           }
                 success:^(NSDictionary *response) {
                   [Cycle cycleFromResponse:response];
                   Day *day = [Day forDate:date];
                   if (!day) {
                     day = [Day withAttributes:@{@"date": date, @"idate": date.dateId}];
                   }

                   if (onSuccess) onSuccess(response);
                 }
                 failure:^(NSError *error) {
                   if(onFailure) onFailure(error);
                 }];
}

- (void)addDays:(NSArray *)days {
  NSMutableArray *currentDays = [self.days mutableCopy];
  if (!currentDays) {
    currentDays = [NSMutableArray arrayWithCapacity:days.count];
  }
  for (Day *day in days) {
    day.cycle = self;
    if (![currentDays containsObject:day]) {
      [currentDays addObject:day];
    }
  }
  self.days = [currentDays sortedArrayUsingComparator:^NSComparisonResult(Day *day1, Day *day2) {
    return [day1.date compare:day2.date];
  }];
}

+ (Cycle *)cycleFromResponse:(NSDictionary *)cycleResponse {
  NSArray *daysResponse = cycleResponse[@"days"];
  if (!daysResponse) {
    daysResponse = @[cycleResponse[@"day"]];
  }

  NSMutableArray *days = [NSMutableArray arrayWithCapacity:daysResponse.count];
  for (NSDictionary *dayAttributes in daysResponse) {
    [days addObject:[Day withAttributes:dayAttributes]];
  }

  NSDate *start = [days.firstObject date];
  NSDate *end = [days.lastObject date];

  NSArray *allCycles = [Cycle all];
  Cycle *cycle;

  for (Cycle *preexistingCycle in allCycles) {
    BOOL startIsAfterCycleStart = [preexistingCycle.startDate laterDate:start] == start;
    BOOL endIsBeforeCycleEnd = [preexistingCycle.endDate earlierDate:end] == end;
    BOOL inCycle = startIsAfterCycleStart && endIsBeforeCycleEnd;
    inCycle = inCycle || [preexistingCycle.startDate isEqualToDate:start];
    inCycle = inCycle || [preexistingCycle.endDate isEqualToDate:end];
    if (inCycle) {
      cycle = preexistingCycle;
      break;
    }
  }

  if (!cycle) {
    cycle = [[Cycle alloc] init];
    if (!kAllCycles) {
      kAllCycles = [NSMutableArray array];
    }
    [kAllCycles addObject:cycle];
  }

  [cycle addDays:days];
  if([cycleResponse[@"coverline"] isNull]) {
    cycle.coverline = nil;
  } else {
    cycle.coverline = cycleResponse[@"coverline"];
  }

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

- (NSInteger)index {
  return [[Cycle all] indexOfObject:self];
}

- (Cycle *)previousCycle {
  return [Cycle atIndex:self.index - 1];
}

- (Cycle *)nextCycle {
  return [Cycle atIndex:self.index + 1];
}

- (NSDate *)endDate {
  return [self.days.lastObject date];
}

- (NSDate *)startDate {
  return [self.days.firstObject date];
}

@end
