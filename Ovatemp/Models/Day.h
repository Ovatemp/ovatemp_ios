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

@interface Day : BaseModel

// The first element of all of these arrays/enums is the value for "null" or "unset"
#define kUnset 0

typedef enum cervicalFluidTypesEnum
{
  CERVICAL_FLUID_STICKY,
  CERVICAL_FLUID_CREAMY,
  CERVICAL_FLUID_EGGWHITE,
} CervicalFluidType;
#define kCervicalFluidTypes @[@"sticky", @"creamy", @"eggwhite"]
@property (nonatomic, retain) NSString* cervicalFluid;

#define kCyclePhaseTypes @[@"period", @"preovulation", @"ovulation", @"postovulation"]
typedef enum cyclePhaseTypesEnum
{
  CYCLE_PHASE_PERIOD,
  CYCLE_PHASE_PREOVULATION,
  CYCLE_PHASE_OVULATION,
  CYCLE_PHASE_POSTOVULATION
} CyclePhaseType;
@property (nonatomic, retain) NSString* cyclePhase;

#define kIntercourseTypes @[@"protected", @"unprotected"]
typedef enum intercourseTypesEnum
{
  INTERCOURSE_PROTECTED,
  INTERCOURSE_UNPROTECTED,
} IntercourseType;
@property (nonatomic, retain) NSString* intercourse;

#define kFerningTypes @[@"positive", @"negative"]
typedef enum ferningTypesEnum
{
  FERNING_POSITIVE,
  FERNING_NEGATIVE,
} FerningType;
@property (nonatomic, retain) NSString* ferning;

#define kMoodTypes @[@"sad", @"worried", @"good", @"amazing"]
typedef enum moodTypesEnum
{
  MOOD_SAD,
  MOOD_WORRIED,
  MOOD_GOOD,
  MOOD_AMAZING
} MoodType;
@property (nonatomic, retain) NSString* mood;

#define kOpkTypes @[@"positive", @"negative"]
typedef enum opkTypesEnum
{
  OPK_POSITIVE,
  OPK_NEGATIVE,
} OpkType;
@property (nonatomic, retain) NSString* opk;

#define kPeriodTypes @[@"none", @"spotting", @"light", @"medium", @"heavy"]
typedef enum periodTypesEnum
{
  PERIOD_NONE,
  PERIOD_SPOTTING,
  PERIOD_LIGHT,
  PERIOD_MEDIUM,
  PERIOD_HEAVY,
} PeriodType;
@property (nonatomic, retain) NSString* period;

#define kPregnancyTestTypes @[@"positive", @"negative"]
typedef enum pregnancyTestTypesEnum
{
  PREGNANCY_TEST_POSITIVE,
  PREGNANCY_TEST_NEGATIVE,
} PregnancyTestType;
@property (nonatomic, retain ) NSString* pregnancyTest;

#define kVaginalSensationTypes @[@"dry", @"wet", @"lube"]
typedef enum vaginalSensationTypesEnum
{
  VAGINAL_SENSATION_DRY,
  VAGINAL_SENSATION_WET,
  VAGINAL_SENSATION_LUBE,
} VaginalSensationType;
@property (nonatomic, retain) NSString* vaginalSensation;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *temperature;

@property (nonatomic, strong) NSMutableArray *medicineIds;
@property (nonatomic, strong) NSMutableArray *supplementIds;
@property (nonatomic, strong) NSMutableArray *symptomIds;

@property (nonatomic, assign) BOOL disturbance;

+ (Day *)forDate:(NSDate *)date;
+ (void)loadDate:(NSDate *)date success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;
- (Day *)nextDay;
- (Day *)previousDay;

- (BOOL)isProperty:(NSString *)key ofType:(NSInteger)type;
- (void)updateProperty:(NSString *)key withValue:(id)value;
- (void)toggleProperty:(NSString *)key withIndex:(NSInteger)index;

- (BOOL)hasMedicine:(Medicine *)medicine;
- (BOOL)hasSupplement:(Supplement *)supplement;
- (BOOL)hasSymptom:(Symptom *)symptom;

- (NSArray *)medicines;
- (NSArray *)supplements;
- (NSArray *)symptoms;

- (void)toggleMedicine:(Medicine *)medicine;
- (void)toggleSupplement:(Supplement *)supplement;
- (void)toggleSymptom:(Symptom *)symptom;

- (void)save;

@end
