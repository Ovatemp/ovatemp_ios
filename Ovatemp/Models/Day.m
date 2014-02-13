//
//  Day.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Day.h"
#import "NSDate+ShortDate.h"

@implementation Day

static NSDictionary *validTypes;

- (void)setValue:(id)value forKey:(NSString *)key {
  if(!validTypes) {
    validTypes = @{
                   @"cervicalFluid": kCervicalFluidTypes,
                   @"cervicalPosition": kCervicalPositionTypes,
                   @"vaginalSensation": kVaginalSensationTypes,
                   @"intercourse": kIntercourseTypes,
                   @"ferning": kFerningTypes,
                   @"pregnancyTest": kPregnancyTestTypes,
                   @"opk": kOpkTypes,
                   @"period": kPeriodTypes
                   };
  }

  if(validTypes[key]) {
    NSArray *possibleValues = validTypes[key];

    // If we have a value outside of the possible values (such as null),
    // set the value to "unset"
    if(![possibleValues containsObject:value]) {
      value = nil;
    }
  }

  NSLog(@"setting value %@ for key %@", value, key);
  [super setValue:value forKey:key];
}

- (NSString *)key {
  return @"date";
}

+ (Day *)forDate:(NSDate *)date {
  Day *day = [Day instances][[date shortDate]];
  return day;
}

@end
