//
//  ILDayStore.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/30/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILDayStore.h"

@interface ILDayStore ()

@property (nonatomic) NSMutableDictionary *days;
@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation ILDayStore

- (id)init
{
    self = [self initWithDays: nil];
    return self;
}

- (id)initWithDays:(NSArray *)days
{
    self = [super init];
    if (self) {
        
        [self addDays: days];
        
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver: self selector: @selector(didLogout:) name: kUserDidLogoutNotification object: nil];
        
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver: self];
}

#pragma mark - Days

- (void)addDays:(NSArray *)days
{
    for (ILDay *day in days) {
        [self addDay: day];
    }
}

- (void)addDay:(ILDay *)day
{
    NSString *dateString = [self.dateFormatter stringFromDate: day.date];
    [self.days setObject: day forKey: dateString];
}

- (ILDay *)dayForDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate: date];
    ILDay *dayOptional = self.days[dateString];
    return dayOptional ?: [[ILDay alloc] initWithDate: date];
}

- (void)reset
{
    DDLogInfo(@"ILDAYSTORE : RESET");
    [self.days removeAllObjects];
}

#pragma mark - Notifications

- (void)didLogout:(NSNotification *)notification
{
    DDLogInfo(@"ILDAYSTORE : USER DID LOGOUT");
    [self reset];
}

#pragma mark - Set/Get

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

- (NSMutableDictionary *)days
{
    if (!_days) {
        _days = [[NSMutableDictionary alloc] init];
    }
    return _days;
}

@end
