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

static NSDictionary *propertyOptions;

- (void)setValue:(id)value forKey:(NSString *)key {
  if(!propertyOptions) {
    propertyOptions = @{
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

  if(propertyOptions[key]) {
    NSArray *possibleValues = propertyOptions[key];

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

- (void)updateProperty:(NSString *)key withIndex:(NSInteger)index {
  NSArray *enumeratedStrings = propertyOptions[key];

  if(!enumeratedStrings) {
    NSLog(@"FAIL: %@ with index %ld", key, (long)index);
    abort();
  }

  [self setValue:enumeratedStrings[index] forKey:key];
  [self scheduleSave];
}

- (BOOL)isProperty:(NSString *)key ofType:(NSInteger)type {
  NSArray *enumeratedStrings = propertyOptions[key];

  return [[self valueForKey:key] isEqualToString:enumeratedStrings[type]];
}

- (void)scheduleSave {
  NSLog(@"we will save someday!");
}

@end
