//
//  Day.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Day.h"

#import "Alert.h"
#import "Cycle.h"
#import "ConnectionManager.h"

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

  self.ignoredAttributes = [NSSet setWithArray:@[@"createdAt", @"updatedAt", @"cycleId", @"userId"]];

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

- (NSString *)description {
  return [NSString stringWithFormat:@"Day (%@)", self.idate];
}

# pragma mark - Navigating days

- (Day *)nextDay {
  return [Day forDate:[self.date dateByAddingTimeInterval:1 * 60 * 60 * 24]];
}

- (Day *)previousDay {
  return [Day forDate:[self.date dateByAddingTimeInterval:-1 * 60 * 60 * 24]];
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
}

- (void)setValue:(id)value forKey:(NSString *)key {
  if(!propertyOptions) {
    propertyOptions = @{
                        @"cervicalFluid": kCervicalFluidTypes,
                        @"cyclePhase": kCyclePhaseTypes,
                        @"vaginalSensation": kVaginalSensationTypes,
                        @"intercourse": kIntercourseTypes,
                        @"ferning": kFerningTypes,
                        @"mood": kMoodTypes,
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

# pragma mark - Tracking dirty attributes

- (void)addDirtyAttribute:(NSString *)key {
  @synchronized(self->dirtyAttributes) {
    // If we haven't already scheduled a save, schedule one to happen after the delay
    if([self->dirtyAttributes count] < 1) {
      Day *day = self;
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, DELAY_BEFORE_SAVE * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [day save];
      });
    }

    [self->dirtyAttributes addObject:key];
  }
}

// This may get called many times in rapid succession, so we want to make it cheap
- (void)save {
  [self saveAndThen:nil];
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
                   if (onSuccess) onSuccess(response);
                 }
                 failure:^(NSError *error) {
                   // HANDLEERROR
                   NSLog(@"day save error: %@", error);
                 }];

}

# pragma mark - Relations

- (NSArray *)medicines {
  NSMutableArray *accum = [[NSMutableArray alloc] initWithCapacity:self.medicineIds.count];

  for(NSNumber *id in self.medicineIds) {
    [accum addObject:[Medicine findByKey:[id description]]];
  }

  return accum;
}

- (NSArray *)supplements {
  NSMutableArray *accum = [[NSMutableArray alloc] initWithCapacity:self.supplementIds.count];

  for(NSNumber *id in self.supplementIds) {
    [accum addObject:[Supplement findByKey:[id description]]];
  }

  return accum;
}

- (NSArray *)symptoms {
  NSMutableArray *accum = [[NSMutableArray alloc] initWithCapacity:self.symptomIds.count];

  for(NSNumber *id in self.symptomIds) {
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
