//
//  ILCycle.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILCycle : NSObject

@property (nonatomic) NSNumber *coverline;
@property (nonatomic) NSDate *peakDate;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *endDate;

@property (nonatomic) NSArray *days;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
