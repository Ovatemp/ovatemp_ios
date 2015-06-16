//
//  CoachingDataStore.h
//  Ovatemp
//
//  Created by Daniel Lozano on 6/4/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ILActivityType){
    ILActivityTypeLifestyle,
    ILActivityTypeAcupressure,
    ILActivityTypeMassage,
    ILActivityTypeMeditation
};

typedef void (^CoachingCompletionBlock)(BOOL status);
typedef void (^CoachingErrorCompletionBlock)(NSError *error);
typedef void (^CoachingEmptyCompletionBlock)();

@interface CoachingDataStore : NSObject

+ (id)sharedSession;

- (void)reloadDataStore;
- (void)saveDataStore;

- (void)getStatusForDate:(NSDate *)date withCompletion:(CoachingCompletionBlock)completion;
- (void)getStatusForActivityType:(ILActivityType)type forDate:(NSDate *)date withCompletion:(CoachingCompletionBlock)completion;
- (void)setStatus:(BOOL)status forActivityType:(ILActivityType)type forDate:(NSDate *)date withCompletion:(CoachingErrorCompletionBlock)completion;

@end
