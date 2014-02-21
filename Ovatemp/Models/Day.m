//
//  Day.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Day.h"
#import "ConnectionManager.h"

@implementation Day

static NSDictionary *propertyOptions;

- (id)init {
  self = [super init];
  if(!self) {
    return nil;
  }

  self.ignoredAttributes = [NSSet setWithArray:@[@"createdAt", @"updatedAt", @"cycleId", @"userId", @"disturbance", @"medicines", @"supplements"]];

  self.medicines = @[@"Painkillers", @"Metamorphin", @"Clomid", @"Progestin", @"Claritin", @"Albuterol", @"Parasol"];
  self.supplements = @[@"Prenatal", @"Calcium", @"The Biggest Horse Pill", @"The Second Biggest Horse Pill", @"Healing Breath", @"Mint Tea", @"Nettle tea", @"Pine tea", @"Green tea extract"];

  return self;
}

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

  [super setValue:value forKey:key];
}

- (NSString *)key {
  return @"date";
}

+ (Day *)forDate:(NSDate *)date {
  Day *day = [Day instances][[date shortDate]];
  return day;
}

- (void)toggleProperty:(NSString *)key withIndex:(NSInteger)index {
  NSArray *enumeratedStrings = propertyOptions[key];
  NSString *value = enumeratedStrings[index];

  NSLog(@"toggling: %@", value);
  if([[self valueForKey:key] isEqualToString:value]) {
    [self setValue:nil forKey:key];
  } else {
    [self setValue:value forKey:key];
  }
  
  [self scheduleSave];
}

- (void)updateProperty:(NSString *)key withValue:(id)value {
  [self setValue:value forKey:key];
  [self scheduleSave];
}

- (BOOL)isProperty:(NSString *)key ofType:(NSInteger)type {
  NSArray *enumeratedStrings = propertyOptions[key];

  return [[self valueForKey:key] isEqualToString:enumeratedStrings[type]];
}

- (void)scheduleSave {
  Day *day = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, DELAY_BEFORE_SAVE * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [day save];
  });
}

- (void)save {
  Day *day = self;
  [ConnectionManager put:@"/days/"
                   params:@{
                            @"day": [day attributes:FALSE],
                            }
                   target:self
                  success:@selector(didSave:)
                  failure:@selector(saveError:)];
}

- (void)didSave:(NSDictionary *)response {
  // NSLog(@"saved day: %@", response);
}

- (void)saveError:(NSError *)error {
  NSLog(@"day save error: %@", error);
}

- (NSString *)description {
  return [NSString stringWithFormat:@"Day (%@)", [self.date shortDate]];
}

@end
