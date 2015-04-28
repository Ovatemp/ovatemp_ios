//
//  ILDay.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILDay.h"

#import "NSArray+ArrayMap.h"

@interface ILDay ()

@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ILDay

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init]; if(!self)return nil;
    
    self.day_id = dictionary[@"id"];
    self.temperature = dictionary[@"temperature"];
    self.date = dictionary[@"date"] ? [self.dateFormatter dateFromString: dictionary[@"date"]] : nil;
    
    self.disturbance = dictionary[@"disturbance"];
    
    self.cervicalFluid = dictionary[@"cervical_fluid"];
    self.cervicalPosition = dictionary[@"cervical_position"];
    self.vaginalSensation = dictionary[@"vaginal_sensation"];
    self.period = dictionary[@"period"];
    self.intercourse = dictionary[@"intercourse"];
    self.ferning = dictionary[@"ferning"];
    self.opk = dictionary[@"opk"];
    self.mood = dictionary[@"mood"];
    
    self.cyclePhase = dictionary[@"cycle_phase"];
    self.cycleDay = dictionary[@"cycle_day"];
    self.inFertilityWindow = dictionary[@"in_fertility_window"];
    
    self.notes = dictionary[@"notes"];
    self.usedOndo = dictionary[@"used_ondo"];
    
    self.supplementIds = dictionary[@"supplement_ids"];
    self.medicineIds = dictionary[@"medicine_ids"];
    self.symptomIds = dictionary[@"symptom_ids"];
    
    return self;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

@end
