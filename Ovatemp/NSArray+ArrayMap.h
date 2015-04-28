//
//  NSArray+ArrayMap.h
//  Ovatemp
//
//  Created by Daniel Lozano on 4/27/15.
//  Copyright (c) 2015 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ArrayMap)

- (NSArray *)dl_map:(id (^)(id inputItem))transformBlock;

@end
