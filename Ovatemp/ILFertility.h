//
//  ILFertility.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/28/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ILFertilityStatusType){
    ILFertilityStatusTypeNoData,
    ILFertilityStatusTypePeriod,
    ILFertilityStatusTypeNotFertile,
    ILFertilityStatusTypeFertile,
    ILFertilityStatusTypePeakFertility
};

@interface ILFertility : NSObject

- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic) ILFertilityStatusType status;
@property (nonatomic) NSString *message;

@end
