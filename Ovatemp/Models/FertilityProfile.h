//
//  FertilityProfile.h
//  Ovatemp
//
//  Created by Flip Sasser on 4/23/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConnectionManager.h"

@interface FertilityProfile : NSObject

+ (void)loadAll;
+ (void)loadAndThen:(ConnectionManagerSuccess)success failure:(ConnectionManagerFailure)failure;

@end
