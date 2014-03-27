//
//  User.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BaseModel.h"
#import "UserProfile.h"

@interface User : BaseModel

+ (User *)current;
+ (void)setCurrent:(User *)user;

@property NSString *email;
@property NSNumber *fertilityProfileId;
@property NSString *fertilityProfileName;
@property NSString *mailchimpLeid;
@property NSString *passwordDigest;
@property UserProfile *profile;

@end
