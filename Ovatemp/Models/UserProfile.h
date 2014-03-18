//
//  UserProfile.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/17/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BaseModel.h"
#import "ConnectionManager.h"

@interface UserProfile : BaseModel

+ (UserProfile *)current;
+ (void)setCurrent:(UserProfile *)userProfile;

@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSDate *dateOfBirth;

@property (nonatomic, assign) NSNumber *tryingToConceive;
@property (nonatomic, assign) NSNumber *fiveDayRule;
@property (nonatomic, assign) NSNumber *dryDayRule;
@property (nonatomic, assign) NSNumber *temperatureShiftRule;
@property (nonatomic, assign) NSNumber *peakDayRule;

- (void)refresh:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;
- (void)save;

@end