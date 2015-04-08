//
//  Day.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Day.h"

#import "Alert.h"
#import "Calendar.h"
#import "Cycle.h"
#import "ConnectionManager.h"

@import HealthKit;

@interface Day() {
  NSMutableSet *dirtyAttributes;
}
@end

@implementation Day

static NSDictionary *propertyOptions;

# pragma mark - Setup

- (id)init {
  self = [super init];
  if(!self) {
    return nil;
  }

  self.ignoredAttributes = [NSSet setWithArray:@[@"createdAt", @"updatedAt", @"cycleId", @"userId", @"temperatureTakenAt"]];

  self->dirtyAttributes = [NSMutableSet set];
    
  return self;
}

+ (NSString *)key {
  return @"idate";
}

+ (Day *)forDate:(NSDate *)date {
  Day *day = [Day findByKey:[date dateId]];

  return day;
}

+ (Day *)today {
  return [self forDate:[NSDate date]];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"Day (%@)", self.idate];
}

# pragma mark - Navigating days

- (Day *)nextDay {
  Day *next = [[Day alloc] init];
  next.date = [self.date dateByAddingTimeInterval:1 * 60 * 60 * 24];
  return next;
}

- (Day *)previousDay {
  Day *previous = [[Day alloc] init];
  previous.date = [self.date dateByAddingTimeInterval:-1 * 60 * 60 * 24];
  return previous;
}

# pragma mark - Generating images

- (NSString *)imageNameForProperty:(NSString *)key {
  NSString *value = [self valueForKey:key];

  return [value capitalizedString];
}

# pragma mark - Massaged property values

- (NSInteger)selectedPropertyForKey:(NSString *)key {
  NSArray *enumeratedStrings = propertyOptions[key];
  id value = [self valueForKey:key];
  return [enumeratedStrings indexOfObject:value];
}

- (void)selectProperty:(NSString *)key withindex:(NSInteger)index {
  [self selectProperty:key withindex:index then:nil];
}

- (void)selectProperty:(NSString *)key withindex:(NSInteger)index then:(ConnectionManagerSuccess)callback {
  id value;
  if (index == NSNotFound) {
    value = nil;
  } else {
    NSArray *enumeratedStrings = propertyOptions[key];
    value = enumeratedStrings[index];
  }

  [self updateProperty:key withValue:value then:callback];
}

- (void)updateProperty:(NSString *)key withValue:(id)value {
  [self updateProperty:key withValue:value then:nil];
}

- (void)updateProperty:(NSString *)key withValue:(id)value then:(ConnectionManagerSuccess)callback {
  [self setValue:value forKey:key];
  [self addDirtyAttribute:key];
  [self saveAndThen:callback];

  if([key isEqualToString: @"temperature"]) {
    [self updateHealthKit];
  }
}

- (void)setValue:(id)value forKey:(NSString *)key {
//  if(!propertyOptions) {
//    propertyOptions = @{
//                        @"cervicalFluid": kCervicalFluidTypes,
//                        @"cyclePhase": kCyclePhaseTypes,
//                        @"vaginalSensation": kVaginalSensationTypes,
//                        @"intercourse": kIntercourseTypes,
//                        @"ferning": kFerningTypes,
//                        @"mood": kMoodTypes,
//                        @"pregnancyTest": kPregnancyTestTypes,
//                        @"opk": kOpkTypes,
//                        @"period": kPeriodTypes,
//                        @"cervical_position": kCervicalPositionTypes
//                        };
//  }
    
    // force resetting of propertyOptions in order to account new new attributes (ie: dry cervical fluid)
    propertyOptions = @{
                        @"cervicalFluid": kCervicalFluidTypes,
                        @"cyclePhase": kCyclePhaseTypes,
                        @"vaginalSensation": kVaginalSensationTypes,
                        @"intercourse": kIntercourseTypes,
                        @"ferning": kFerningTypes,
                        @"mood": kMoodTypes,
                        @"pregnancyTest": kPregnancyTestTypes,
                        @"opk": kOpkTypes,
                        @"period": kPeriodTypes,
                        @"cervical_position": kCervicalPositionTypes
                        };

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

# pragma mark - Tracking dirty attributes

- (void)addDirtyAttribute:(NSString *)key {
  @synchronized(self->dirtyAttributes) {
    // If we haven't already scheduled a save, schedule one to happen after the delay
    [self->dirtyAttributes addObject:key];
  }
}

// This may get called many times in rapid succession, so we want to make it cheap
- (void)save {
  [self saveAndThen:nil];
}

- (BOOL)isEqual:(id)object {
  if ([object isKindOfClass:[self class]]) {
    return [self.idate isEqualToString:[object idate]];
  }
  return NO;
}

- (void)saveAndThen:(ConnectionManagerSuccess)onSuccess {
  NSDictionary *attributes;

  @synchronized(self->dirtyAttributes) {
    if([self->dirtyAttributes count] < 1) {
      return;
    }

    // Make sure we send back the date, since we are using a different local identifier
    [self->dirtyAttributes addObject:@"date"];

    attributes = [self attributesForKeys:self->dirtyAttributes camelCase:FALSE];
    [self->dirtyAttributes removeAllObjects];
  }

  [ConnectionManager put:@"/days/"
                  params:@{
                           @"day": attributes,
                           }
                 success:^(NSDictionary *response) {
                   [Cycle cycleFromResponse:response];
                   [Calendar setDate:self.date];
                   if (onSuccess) onSuccess(response);
                 }
                 failure:^(NSError *error) {
                   [Alert presentError:error];
                 }];

}

# pragma mark - HealthKit

- (void)updateHealthKit {
  if ([[NSUserDefaults standardUserDefaults] boolForKey:HKCONNECTION]) {
    if(self.temperature) {
      NSString *identifier = HKQuantityTypeIdentifierBodyTemperature;
      HKQuantityType *tempType = [HKObjectType quantityTypeForIdentifier:identifier];

      HKQuantity *myTemp = [HKQuantity quantityWithUnit:[HKUnit degreeFahrenheitUnit]
                                            doubleValue: [self.temperature floatValue]];

      HKQuantitySample *temperatureSample = [HKQuantitySample quantitySampleWithType: tempType
                                                                            quantity: myTemp
                                                                           startDate: self.date
                                                                             endDate: self.date
                                                                            metadata: nil];
      HKHealthStore *healthStore = [[HKHealthStore alloc] init];
      [healthStore saveObject: temperatureSample withCompletion:^(BOOL success, NSError *error) {
        NSLog(@"I saved to healthkit");
      }];
    }
  }
  else {
    NSLog(@"Could not save to healthkit. No connection could be made");
  }
}

# pragma mark - Relations

- (NSArray *)medicines {
  NSMutableArray *accum = [[NSMutableArray alloc] initWithCapacity:self.medicineIds.count];

  for(NSNumber *id in self.medicineIds) {
    Medicine *medicine = [Medicine findByKey:[id description]];
    if (medicine) {
      [accum addObject:medicine];
    } else {
      NSLog(@"Could not find medicine for %@", id);
    }
  }

  return accum;
}

- (NSArray *)supplements {
  NSMutableArray *accum = [[NSMutableArray alloc] initWithCapacity:self.supplementIds.count];

  for (NSNumber *id in self.supplementIds) {
    Supplement *supplement = [Supplement findByKey:[id description]];
    if (supplement) {
      [accum addObject:supplement];
    } else {
      NSLog(@"Could not find supplement for %@", id);
    }
  }

  return accum;
}

- (NSArray *)symptoms {
  NSMutableArray *accum = [[NSMutableArray alloc] initWithCapacity:self.symptomIds.count];

  for (NSNumber *id in self.symptomIds) {
    Symptom *symptom = [Symptom findByKey:[id description]];
    if (symptom) {
      [accum addObject:symptom];
    } else {
      NSLog(@"Could not find symptom for %@", id);
    }
  }

  return accum;
}

- (BOOL)hasMedicine:(Medicine *)medicine {
  return [self.medicineIds containsObject:medicine.id];
}

- (BOOL)hasSupplement:(Supplement *)supplement {
  return [self.supplementIds containsObject:supplement.id];
}

- (BOOL)hasSymptom:(Symptom *)symptom {
  return [self.symptomIds containsObject:symptom.id];
}

- (void)toggleMedicine:(Medicine *)medicine {
  if([self hasMedicine:medicine]) {
    [self.medicineIds removeObject:medicine.id];
  } else {
    [self.medicineIds addObject:medicine.id];
  }

  [self addDirtyAttribute:@"medicineIds"];
}

- (void)toggleSupplement:(Supplement *)supplement {
  if([self hasSupplement:supplement]) {
    [self.supplementIds removeObject:supplement.id];
  } else {
    [self.supplementIds addObject:supplement.id];
  }

  [self addDirtyAttribute:@"supplementIds"];
}

- (void)toggleSymptom:(Symptom *)symptom {
  if([self hasSymptom:symptom]) {
    [self.symptomIds removeObject:symptom.id];
  } else {
    [self.symptomIds addObject:symptom.id];
  }

  [self addDirtyAttribute:@"symptomIds"];
}

@end
