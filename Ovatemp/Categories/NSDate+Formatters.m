//
//  NSDate+Formatters.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "NSDate+Formatters.h"

@implementation NSDate (Formatters)

static NSDateFormatter *__monthDateFormatter;
- (NSString *)shortMonth {
  if(!__monthDateFormatter){
    __monthDateFormatter = [[NSDateFormatter alloc] init];
    [__monthDateFormatter setDateFormat:@"MMM"];
  }

  return [__monthDateFormatter stringFromDate:self];
}

static NSDateFormatter *__classicDateFormatter;
- (NSString *)classicDate {
  if(!__classicDateFormatter){
    __classicDateFormatter = [[NSDateFormatter alloc] init];
    [__classicDateFormatter setDateFormat:@"MM/dd/yyyy"];
  }

  return [__classicDateFormatter stringFromDate:self];
}

static NSDateFormatter *__dateIdDateFormatter;
- (NSString *)dateId {
  if(!__dateIdDateFormatter){
    __dateIdDateFormatter = [[NSDateFormatter alloc] init];
    [__dateIdDateFormatter setDateFormat:@"y-MM-dd"];
  }

  return [__dateIdDateFormatter stringFromDate:self];
}

@end
