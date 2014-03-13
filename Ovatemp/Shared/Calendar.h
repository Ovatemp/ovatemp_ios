//
//  Calendar.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cycle.h"

@interface Calendar : NSObject

+ (Day *)day;
+ (void)setDate:(NSDate *)date;
+ (void)resetDate;
+ (Calendar *)sharedInstance;
+ (void)stepDay:(NSInteger)offset;
+ (BOOL)isOnToday;

@end
