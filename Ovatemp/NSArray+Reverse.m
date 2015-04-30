//
//  NSArray+Reverse.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/29/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "NSArray+Reverse.h"

@implementation NSArray (Reverse)

- (NSArray *)dl_reverse
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity: [self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end