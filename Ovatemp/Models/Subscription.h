//
//  Subscription.h
//  Ovatemp
//
//  Created by Jason Welch on 9/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BaseModel.h"
#import "ConnectionManager.h"

@interface Subscription : BaseModel

+ (Subscription *)current;
+ (void)setCurrent:(Subscription *)subscription;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *expiresAt;
@property NSInteger userId;

- (void) save;
- (void) printDetails;
@end
