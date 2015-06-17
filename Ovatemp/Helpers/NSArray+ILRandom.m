//
//  NSArray+ILRandom.m
//  Ovatemp
//
//  Created by Daniel Lozano on 6/17/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "NSArray+ILRandom.h"

@implementation NSArray (ILRandom)

- (NSArray *)shuffle
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray: self];
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [tempArray exchangeObjectAtIndex: i withObjectAtIndex: exchangeIndex];
    }
    return [NSArray arrayWithArray: tempArray];
}

@end
