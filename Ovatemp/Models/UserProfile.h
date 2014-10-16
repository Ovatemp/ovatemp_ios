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
@property (nonatomic, strong) NSString *email;

@property (nonatomic, assign) BOOL tryingToConceive;
@property (nonatomic, assign) BOOL fiveDayRule;
@property (nonatomic, assign) BOOL dryDayRule;
@property (nonatomic, assign) BOOL temperatureShiftRule;
@property (nonatomic, assign) BOOL peakDayRule;

- (void)refresh:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;
- (void)save;

@end