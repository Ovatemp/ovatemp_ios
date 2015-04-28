//
//  ILCycle.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILCycle.h"

#import "NSArray+ArrayMap.h"
#import "ILDay.h"

@interface ILCycle ()

@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ILCycle

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init]; if (!self) return nil;
    
    self.coverline = dictionary[@"coverline"];
    self.peakDate = dictionary[@"peak_date"] ? [self.dateFormatter dateFromString: dictionary[@"peak_date"]] : nil;
    self.startDate = dictionary[@"start_date"] ? [self.dateFormatter dateFromString: dictionary[@"start_date"]] : nil;
    self.endDate = dictionary[@"end_date"] ? [self.dateFormatter dateFromString: dictionary[@"end_date"]] : nil;
    
    self.days = [dictionary[@"days"] dl_map:^ ILDay *(NSDictionary *day) {
        return [[ILDay alloc] initWithDictionary: day];
    }];
    
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
