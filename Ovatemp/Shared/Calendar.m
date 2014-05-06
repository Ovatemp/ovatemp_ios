//
//  Calendar.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Calendar.h"

@interface Calendar ()

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) Day *day;

@end

@implementation Calendar

static Calendar *sharedCalendar = nil;

+ (Calendar *)sharedInstance
{
  static dispatch_once_t _singletonPredicate;

  dispatch_once(&_singletonPredicate, ^{
    sharedCalendar = [[super alloc] init];
    sharedCalendar.date = [NSDate date];
  });

  return sharedCalendar;
}

+ (NSDate *)date {
  return [[Calendar sharedInstance] date];
}

+ (Day *)day {
  return [[Calendar sharedInstance] day];
}

+ (void)setDate:(NSDate *)date {
  Calendar *cal = [Calendar sharedInstance];
  cal.date = date;
  [cal updateDay];
}

- (void)updateDay {
  NSLog(@"Fetching day for date %@", self.date);
  NSLog(@"Searching through %@", [Day instances]);
  NSLog(@"%@", [Day forDate:self.date]);
  Day *day = [Day forDate:self.date];
  if (day) {
    self.day = day;
    return;
  }
  NSLog(@"No day found");

  [Cycle loadDate:self.date
          success:^(NSDictionary *response) {
            self.day = [Day forDate:self.date];
          }
          failure:^(NSError *error) {
            [Alert presentError:error];
          }];
}

+ (void)resetDate {
  [Calendar setDate:[NSDate date]];
}

+ (void)stepDay:(NSInteger)offset {
  NSDate *date = [Calendar date];

  NSInteger offsetInSeconds = offset * 60 * 60 * 24;

  [Calendar setDate:[NSDate dateWithTimeInterval:offsetInSeconds sinceDate:date]];
}

+ (BOOL)isOnToday {
  return [[Calendar sharedInstance] isSameDayWith:[NSDate date]];
}

- (BOOL)isSameDayWith:(NSDate*)compareDate {
  NSCalendar* calendar = [NSCalendar currentCalendar];

  unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
  NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self.date];
  NSDateComponents* comp2 = [calendar components:unitFlags fromDate:compareDate];

  return [comp1 day] == [comp2 day] &&
         [comp1 month] == [comp2 month] &&
         [comp1 year] == [comp2 year];
}

@end
