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

typedef void (^CompletionBlock)(id object, NSError *error);
typedef void (^ErrorCompletionBlock)(NSError *error);
typedef void (^EmptyCompletionBlock)();

@interface CoachingDataStore : NSObject

+ (id)sharedSession;

- (void)reloadDataStore;
- (void)saveDataStore;

- (BOOL)getStatusForActivityType:(ILActivityType)type forDate:(NSDate *)date withCompletion:(CompletionBlock)completion;
- (void)setStatus:(BOOL)status forActivityType:(ILActivityType)type forDate:(NSDate *)date withCompletion:(ErrorCompletionBlock)completion;

@end
