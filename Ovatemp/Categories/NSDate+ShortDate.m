//
//  NSDate+ShortDate.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "NSDate+ShortDate.h"

@implementation NSDate (ShortDate)

static NSDateFormatter *__shortDateDateFormatter;
- (NSString *)shortDate {
  if(!__shortDateDateFormatter){
    __shortDateDateFormatter = [[NSDateFormatter alloc] init];
    [__shortDateDateFormatter setDateFormat:@"y-MM-d"];
  }

  return [__shortDateDateFormatter stringFromDate:self];
}

@end
