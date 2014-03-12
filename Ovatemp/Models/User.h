//
//  User.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel

+ (User *)current;
+ (void)setCurrent:(User *)user;

@property NSString *email;
@property NSString *firstName;
@property NSString *lastName;
@property NSString *mailchimpLeid;
@property NSString *passwordDigest;
@property BOOL *hasCycles;

@end
