//
//  Cycle.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Day.h"

typedef void (^CycleDateLoadSuccess) ();
typedef void (^CycleDateLoadFailure) (NSError *error);

@interface Cycle : NSObject

+ (NSArray *)all;
+ (BOOL)fullyLoaded;
+ (void)loadAllAnd:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;
+ (void)loadDate:(NSDate *)date success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;
+ (NSDate *)firstDate;
+ (NSDate *)lastDate;
+ (NSInteger)totalDays;

- (Cycle *)previousCycle;
- (Cycle *)nextCycle;
- (NSString *)rangeString;

@property (nonatomic) NSNumber *cycleId;
@property (readonly) NSDate *endDate;
@property (readonly) NSDate *startDate;
@property (nonatomic, strong) NSArray *days;
@property (nonatomic, strong) NSNumber *coverline;
@property (nonatomic, strong) NSString *fertilityWindow;

+ (Cycle *)cycleFromResponse:(NSDictionary *)cycleResponse;

@end
