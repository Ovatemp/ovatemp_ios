//
//  ILDayStore.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/30/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ILDay.h"

@interface ILDayStore : NSObject

- (id)initWithDays:(NSArray *)days;

- (void)addDays:(NSArray *)days;
- (void)addDay:(ILDay *)day;
- (ILDay *)dayForDate:(NSDate *)date;

- (void)reset;

@end
