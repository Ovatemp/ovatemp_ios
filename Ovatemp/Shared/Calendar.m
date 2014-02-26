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

@end

@implementation Calendar

static Calendar *sharedObject = nil;

+ (Calendar *)sharedInstance
{
  static dispatch_once_t _singletonPredicate;

  dispatch_once(&_singletonPredicate, ^{
    sharedObject = [[super allocWithZone:nil] init];
    sharedObject.date = [NSDate date];
  });

  return sharedObject;
}

+ (NSDate *)date {
  return [[Calendar sharedInstance] date];
}

+ (void)setDate:(NSDate *)date {
  Calendar *cal = [Calendar sharedInstance];
  cal.date = date;
}

+ (void)resetDate {
  Calendar *cal = [Calendar sharedInstance];
  cal.date = [NSDate date];
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

+ (id)allocWithZone:(NSZone *)zone
{
  return [self sharedInstance];
}


@end
