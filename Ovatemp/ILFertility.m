//
//  ILFertility.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/28/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "ILFertility.h"

@implementation ILFertility

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init]; if(!self) return nil;
    
    self.status = [self typeForString: dictionary[@"status"]];
    self.message = dictionary[@"message"];
    
    return self;
}

- (ILFertilityStatusType)typeForString:(NSString *)type
{
    if ([type isEqualToString: @"no data"]) {
        return ILFertilityStatusTypeNoData;
        
    }else if ([type isEqualToString: @"period"]) {
        return ILFertilityStatusTypePeriod;
        
    }else if ([type isEqualToString: @"not fertile"]) {
        return ILFertilityStatusTypeNotFertile;
        
    }else if ([type isEqualToString: @"fertile"]) {
        return ILFertilityStatusTypeFertile;
        
    }else if ([type isEqualToString: @"peak fertile"]) {
        return ILFertilityStatusTypePeakFertility;
        
    }else{
        return ILFertilityStatusTypeNoData;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"STATUS: %ld \n MESSAGE: %@", (long)self.status, self.message];
}

@end
