//
//  NSDate+CalendarOps.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/6/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "NSDate+CalendarOps.h"

@implementation NSDate (CalendarOps)

- (NSInteger)daysTilDate:(NSDate*)toDateTime
{
  NSDate *fromDate;
  NSDate *toDate;

  NSCalendar *calendar = [NSCalendar currentCalendar];

  [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
               interval:NULL forDate:self];
  [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
               interval:NULL forDate:toDateTime];

  NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                             fromDate:fromDate toDate:toDate options:0];

  return [difference day];
}

- (NSDate *)addDays:(NSUInteger)days
{
  NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
  dateComponents.day = days;
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = [calendar dateByAddingComponents:dateComponents
                                                   toDate:self
                                                  options:0];
  return date;
}

- (NSInteger)daysInMonth {
  NSRange days = [[NSCalendar currentCalendar]
                  rangeOfUnit:NSDayCalendarUnit
                  inUnit:NSMonthCalendarUnit
                  forDate:self];

  return days.length;
}

- (NSInteger)year {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:self];
  return dateComponents.year;
}

@end
