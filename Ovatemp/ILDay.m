//
//  ILDay.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILDay.h"

#import "NSArray+ArrayMap.h"
#import "NSDictionary+WithoutNSNull.h"

#import "Supplement.h"
#import "Medicine.h"
#import "Symptom.h"

@interface ILDay ()

@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ILDay

- (id)initWithDate:(NSDate *)date
{
    self = [super init]; if(!self)return nil;
    
    self.date = date;
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init]; if(!self)return nil;
        
    self.day_id = [dictionary dl_objectForKeyWithNil: @"id"];
    self.cycleId = [dictionary dl_objectForKeyWithNil: @"cycle_id"];
    self.temperature = [dictionary dl_objectForKeyWithNil: @"temperature"];
    
    self.date = ![dictionary[@"date"] isKindOfClass: [NSNull class]] ? [self.dateFormatter dateFromString: dictionary[@"date"]] : nil;
    
    self.disturbance = [[dictionary dl_objectForKeyWithNil: @"disturbance"] boolValue];
    
    self.cervicalFluid = [dictionary dl_objectForKeyWithNil: @"cervical_fluid"];
    self.cervicalPosition = [dictionary dl_objectForKeyWithNil: @"cervical_position"];
    self.vaginalSensation = [dictionary dl_objectForKeyWithNil: @"vaginal_sensation"];
    self.period = [dictionary dl_objectForKeyWithNil: @"period"];
    self.intercourse = [dictionary dl_objectForKeyWithNil: @"intercourse"];
    self.ferning = [dictionary dl_objectForKeyWithNil: @"ferning"];
    self.opk = [dictionary dl_objectForKeyWithNil: @"opk"];
    self.mood = [dictionary dl_objectForKeyWithNil: @"mood"];
    
    self.cyclePhase = [dictionary dl_objectForKeyWithNil: @"cycle_phase"];
    self.cycleDay = [dictionary dl_objectForKeyWithNil: @"cycle_day"];
    self.inFertilityWindow = [[dictionary dl_objectForKeyWithNil: @"in_fertility_window"] boolValue];
    
    self.notes = [dictionary dl_objectForKeyWithNil: @"notes"];
    self.usedOndo = [[dictionary dl_objectForKeyWithNil: @"used_ondo"] boolValue];
    
    self.supplementIds = [dictionary dl_objectForKeyWithNil: @"supplement_ids"];
    self.medicineIds = [dictionary dl_objectForKeyWithNil: @"medicine_ids"];
    self.symptomIds = [dictionary dl_objectForKeyWithNil: @"symptom_ids"];
        
    self.fertility = [[ILFertility alloc] initWithDictionary: dictionary[@"fertility"]];
    
    return self;
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat: @"ID: %@ \n DATE: %@ \n TEMPERATURE: %@ \n FERTILITY: %@ \n USED ONDO: %@", self.day_id, self.date, self.temperature, self.fertility, self.usedOndo ? @"YES" : @"NO"];
    return description;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

#pragma mark - Medicines/Supplements/Symptoms

- (NSArray *)medicines
{
    NSMutableArray *accum = [[NSMutableArray alloc] initWithCapacity: self.medicineIds.count];
    
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

- (NSArray *)supplements
{
    NSMutableArray *accum = [[NSMutableArray alloc] initWithCapacity: self.supplementIds.count];
    
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

- (NSArray *)symptoms
{
    NSMutableArray *accum = [[NSMutableArray alloc] initWithCapacity: self.symptomIds.count];
    
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

@end
