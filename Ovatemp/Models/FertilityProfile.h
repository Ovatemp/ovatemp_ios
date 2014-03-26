//
//  FertilityProfile.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/26/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BaseModel.h"

@interface FertilityProfile : BaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDictionary *coachingContent;

@end
