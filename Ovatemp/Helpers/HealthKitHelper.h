//
//  HealthKitHelper.h
//  Ovatemp
//
//  Created by Daniel Lozano on 5/18/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock)(id object, NSError *error);

@interface HealthKitHelper : NSObject

/**
 *  This method creates a singleton object and initializes it.
 *
 *  @return Singleton HealthKitHelper instance.
 */
+ (id)sharedSession;

///-----------------
/// @name Retrieving values from HealthKit
///-----------------

/**
 *  Gets the user's last weight recording, if any.
 *
 *  @param completion Block that is called when finished. Includes retrieved weight as a NSNumber, and error if any.
 */
- (void)getWeightWithCompletion:(CompletionBlock)completion;

/**
 *  Gets the user's last height recording, if any.
 *
 *  @param completion Block that is called when finished. Includes retrieved height as a NSNumber, and error if any.
 */
- (void)getHeightWithCompletion:(CompletionBlock)completion;

///-----------------
/// @name Updating values in HealthKit
///-----------------

/**
 *  Updates the user's temperature for the given date.
 *
 *  @param temp The temperature (float) value for the given date.
 *  @param date The date that is going to be used to update the temperature on.
 */
- (void)updateTemperature:(float)temp forDate:(NSDate *)date;

@end
