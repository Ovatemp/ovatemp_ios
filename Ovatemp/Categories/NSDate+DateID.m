//
//  NSDate+ShortDate.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "NSDate+DateID.h"

@implementation NSDate (DateID)

static NSDateFormatter *__dateIdDateFormatter;
- (NSString *)dateId {
  if(!__dateIdDateFormatter){
    __dateIdDateFormatter = [[NSDateFormatter alloc] init];
    [__dateIdDateFormatter setDateFormat:@"y-MM-dd"];
  }

  return [__dateIdDateFormatter stringFromDate:self];
}

@end
