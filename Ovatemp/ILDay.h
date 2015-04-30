//
//  ILDay.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ILFertility.h"

@interface ILDay : NSObject

@property (nonatomic) NSNumber *day_id;
@property (nonatomic) NSNumber *temperature; // float
@property (nonatomic) NSDate *date;

@property (nonatomic) BOOL disturbance;

@property (nonatomic) NSString *cervicalFluid;
@property (nonatomic) NSString *cervicalPosition;
@property (nonatomic) NSString *vaginalSensation;
@property (nonatomic) NSString *period;
@property (nonatomic) NSString *intercourse;
@property (nonatomic) NSString *ferning;
@property (nonatomic) NSString *opk;
@property (nonatomic) NSString *mood;

@property (nonatomic) NSString *cyclePhase;
@property (nonatomic) NSNumber *cycleDay; // int
@property (nonatomic) BOOL inFertilityWindow;

@property (nonatomic) NSString *notes;
@property (nonatomic) BOOL usedOndo;

@property (nonatomic) NSArray *supplementIds;
@property (nonatomic) NSArray *medicineIds;
@property (nonatomic) NSArray *symptomIds;

@property (nonatomic) ILFertility *fertility;

- (id)initWithDictionary:(NSDictionary *)dictionary;

- (NSArray *)medicines;
- (NSArray *)supplements;
- (NSArray *)symptoms;

@end
