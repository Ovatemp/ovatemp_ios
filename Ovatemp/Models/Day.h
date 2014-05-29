//
//  Day.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "Medicine.h"
#import "Supplement.h"
#import "Symptom.h"

@class Cycle;

@interface Day : BaseModel

#define kCervicalFluidTypes @[@"sticky", @"creamy", @"eggwhite"]
@property (nonatomic, retain) NSString* cervicalFluid;

#define kCyclePhaseTypes @[@"period", @"preovulation", @"ovulation", @"postovulation"]
typedef enum cyclePhaseTypesEnum : NSUInteger
{
  CYCLE_PHASE_PERIOD,
  CYCLE_PHASE_PREOVULATION,
  CYCLE_PHASE_OVULATION,
  CYCLE_PHASE_POSTOVULATION
} CyclePhaseType;
@property (nonatomic, retain) NSString* cyclePhase;

#define kIntercourseTypes @[@"protected", @"unprotected"]
@property (nonatomic, retain) NSString* intercourse;

#define kFerningTypes @[@"positive", @"negative"]
@property (nonatomic, retain) NSString* ferning;

#define kMoodTypes @[@"sad", @"moody", @"good", @"amazing"]
@property (nonatomic, retain) NSString* mood;

#define kOpkTypes @[@"positive", @"negative"]
@property (nonatomic, retain) NSString* opk;

#define kPeriodTypes @[@"spotting", @"light", @"medium", @"heavy"]
typedef enum periodTypesEnum : NSUInteger
{
  PERIOD_NONE,
  PERIOD_SPOTTING,
  PERIOD_LIGHT,
  PERIOD_MEDIUM,
  PERIOD_HEAVY,
} PeriodType;
@property (nonatomic, retain) NSString* period;

#define kPregnancyTestTypes @[@"positive", @"negative"]
@property (nonatomic, retain ) NSString* pregnancyTest;

#define kVaginalSensationTypes @[@"dry", @"wet", @"lube"]
@property (nonatomic, retain) NSString* vaginalSensation;

@property (nonatomic, strong) NSString *idate;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *temperature;

@property (nonatomic, strong) NSMutableArray *medicineIds;
@property (nonatomic, strong) NSMutableArray *supplementIds;
@property (nonatomic, strong) NSMutableArray *symptomIds;

@property (nonatomic, strong) NSNumber *cycleDay;
@property (nonatomic, strong) NSNumber *cycleId;


@property (nonatomic, assign) BOOL disturbance;
@property (nonatomic, assign) BOOL inFertilityWindow;

@property (nonatomic, strong) Cycle *cycle;

+ (Day *)forDate:(NSDate *)date;
+ (Day *)today;
- (Day *)nextDay;
- (Day *)previousDay;

- (NSInteger)selectedPropertyForKey:(NSString *)key;
- (void)selectProperty:(NSString *)key withindex:(NSInteger)index;
- (void)selectProperty:(NSString *)key withindex:(NSInteger)index then:(ConnectionManagerSuccess)callback;
- (void)updateProperty:(NSString *)key withValue:(id)value;
- (void)updateProperty:(NSString *)key withValue:(id)value then:(ConnectionManagerSuccess)callback;

- (BOOL)hasMedicine:(Medicine *)medicine;
- (BOOL)hasSupplement:(Supplement *)supplement;
- (BOOL)hasSymptom:(Symptom *)symptom;

- (NSArray *)medicines;
- (NSArray *)supplements;
- (NSArray *)symptoms;

- (void)toggleMedicine:(Medicine *)medicine;
- (void)toggleSupplement:(Supplement *)supplement;
- (void)toggleSymptom:(Symptom *)symptom;

- (NSString *)imageNameForProperty:(NSString *)key;

- (void)save;

@end
