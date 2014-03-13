//
//  Cycle.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Day.h"

@interface Cycle : NSObject

+ (void)loadDate:(NSDate *)date success:(ConnectionManagerSuccess)onSuccess failure:(ConnectionManagerFailure)onFailure;
- (Cycle *)initWithDay:(Day *)day;
- (Cycle *)previousCycle;
- (Cycle *)nextCycle;

@property (nonatomic, strong) NSArray *days;
@property (nonatomic, strong) NSNumber *coverline;
@property (nonatomic, strong) NSString *fertilityWindow;

@end
