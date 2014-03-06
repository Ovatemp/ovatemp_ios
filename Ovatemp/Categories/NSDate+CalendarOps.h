//
//  NSDate+CalendarOps.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/6/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CalendarOps)

- (NSDate *)addDays:(NSUInteger)days;
- (NSInteger)daysInMonth;
- (NSInteger)daysTilDate:(NSDate*)toDateTime;
- (NSDateComponents *)differenceWithDate:(NSDate *)to ofUnit:(NSCalendarUnit)unit;

@end
