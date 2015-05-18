//
//  HealthKitHelper.m
//  Ovatemp
//
//  Created by Daniel Lozano on 5/18/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "HealthKitHelper.h"

#import "HKHealthStore+AAPLExtensions.h"

@interface HealthKitHelper ()

@property (nonatomic) HKHealthStore *healthStore;
@property (nonatomic) NSMutableDictionary *units;

@end

@implementation HealthKitHelper

+ (id)sharedSession
{
    static HealthKitHelper *_instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[HealthKitHelper alloc] init];
    });
    
    return _instance;
}

- (id)init
{
    self = [super init]; if (!self) return nil;
    
    [self setUpHealthKit];
    
    return self;
}

- (void)setUpHealthKit
{
    if([HKHealthStore isHealthDataAvailable]) {
        self.healthStore = [[HKHealthStore alloc] init];
        [self.healthStore requestAuthorizationToShareTypes: [self writeDataTypes]
                                                 readTypes: [self readDataTypes]
                                                completion:^(BOOL success, NSError *error) {
                                                    
                                                    if (success) {
                                                        DDLogInfo(@"%s : SUCCESFULLY CONNECTED TO HEALTH-KIT", __PRETTY_FUNCTION__);
                                                    }else{
                                                        DDLogError(@"%s : ERROR CONNECTING TO HEALTHKIT", __PRETTY_FUNCTION__);
                                                    }
        }];
    }

}

#pragma mark - HealthKit Access

#pragma mark - Getting values from HealthKit

- (void)getWeightWithCompletion:(CompletionBlock)completion
{
    HKQuantityType *weightType = [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierBodyMass];
        
    [self getLastDoubleValueWithType: weightType completion: completion];
}

- (void)getHeightWithCompletion:(CompletionBlock)completion
{
    HKQuantityType *heightType = [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierHeight];
    
    [self getLastDoubleValueWithType: heightType completion: completion];
}

- (void)getLastDoubleValueWithType:(HKQuantityType *)type completion:(CompletionBlock)completion
{
    [self.healthStore aapl_mostRecentQuantitySampleOfType: type predicate: nil completion: ^(HKQuantity *mostRecentQuantity, NSError *error) {
        if (!mostRecentQuantity) {
            
            NSError *error = [self errorForType: type];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil, error);
            });
            
        }else{
            HKUnit *unit = [self unitForType: type];
            double value = [mostRecentQuantity doubleValueForUnit: unit];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(@(value), nil);
            });
        }
    }];
}

#pragma mark - Updating values in HealthKit

- (void)updateTemperature:(float)temp forDate:(NSDate *)date
{
    if (!date) {
        return;
    }
    
    HKQuantityType *temperatureType = [HKObjectType quantityTypeForIdentifier: HKQuantityTypeIdentifierBodyTemperature];
    HKQuantity *temperatureQuantity = [HKQuantity quantityWithUnit: [self unitForType: temperatureType] doubleValue: temp];
    
    HKQuantitySample *temperatureSample = [HKQuantitySample quantitySampleWithType: temperatureType
                                                                          quantity: temperatureQuantity
                                                                         startDate: date
                                                                           endDate: date
                                                                          metadata: nil];
    
    HKHealthStore *healthStore = [[HKHealthStore alloc] init];
    [healthStore saveObject: temperatureSample withCompletion:^(BOOL success, NSError *error) {
        if (success) {
            DDLogInfo(@"%s : SUCCESFULLY SAVED TEMPERATURE TO HEALTHKIT", __PRETTY_FUNCTION__);
        }else{
            DDLogError(@"%s : ERROR = %@", __PRETTY_FUNCTION__, error.localizedDescription);
        }
    }];

}

#pragma mark - Read/Write Types

- (NSSet *)writeDataTypes
{
    HKQuantityType *tempQuantityType = [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierBodyTemperature];
    return [[NSSet alloc] initWithObjects: tempQuantityType, nil];
}

- (NSSet *)readDataTypes
{
    HKQuantityType *heightQuantityType = [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierHeight];
    HKQuantityType *weightQuantitytype = [HKQuantityType quantityTypeForIdentifier: HKQuantityTypeIdentifierBodyMass];
    return [[NSSet alloc] initWithObjects: heightQuantityType, weightQuantitytype, nil];
}

#pragma mark - Error Handling

- (NSError *)errorForType:(HKQuantityType *)quantityType
{
    NSError *error;
    
    if ([quantityType.identifier isEqualToString: HKQuantityTypeIdentifierBodyMass]) {
        error = [NSError errorWithDomain: @"com.ovatemp.ovatemp" code: 1 userInfo: @{NSLocalizedDescriptionKey : @"Error getting weight."}];
        
    }else if([quantityType.identifier isEqualToString: HKQuantityTypeIdentifierHeight]){
        error = [NSError errorWithDomain: @"com.ovatemp.ovatemp" code: 2 userInfo: @{NSLocalizedDescriptionKey : @"Error getting height."}];
    }
    
    return error;
}

#pragma mark - Units

- (HKUnit *)unitForType:(HKQuantityType *)quantityType
{
    HKUnit *unit;
    
    // Get unit from user supplied dictionary.
    if (self.unitsForQuantityTypes) {
        unit = self.unitsForQuantityTypes[quantityType];
        if (unit) {
            return unit;
        }
    }
    
    // Get unit from delegate
    if ([self.delegate respondsToSelector: @selector(unitForQuantityType:)]){
        unit = [self.delegate unitForQuantityType: quantityType];
        if (unit) {
            return unit;
        }
    }
    
    // If nothing is supplied, fall back to defaults.
    unit = self.units[quantityType];
    
    return unit;
}

#pragma mark - Set/Get

- (NSMutableDictionary *)units
{
    if (!_units) {
        _units = [[NSMutableDictionary alloc] initWithDictionary: [self unitDefaults]];
    }
    return _units;
}

#pragma mark - Defaults

- (NSDictionary *)unitDefaults
{
    return @{HKQuantityTypeIdentifierHeight : [HKUnit inchUnit],
             HKQuantityTypeIdentifierBodyMass : [HKUnit poundUnit],
             HKQuantityTypeIdentifierBodyTemperature : [HKUnit degreeFahrenheitUnit]};
}

@end
