//
//  NSArray+ArrayMap.m
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import "NSArray+ArrayMap.h"

@implementation NSArray (ArrayMap)

- (NSArray *)dl_map:(id (^)(id inputItem))transformBlock
{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity: [self count]];
    
    for (id item in self) {
        id newItem = transformBlock(item);
        [newArray addObject: newItem];
    }
    
    return [NSArray arrayWithArray: newArray];
}

@end
