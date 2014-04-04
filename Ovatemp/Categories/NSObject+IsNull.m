//
//  NSObject+IsNull.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "NSObject+IsNull.h"

@implementation NSObject (IsNull)

- (BOOL)isNull {
  return [self isKindOfClass:[NSNull class]] || [self isEqual:[NSNull null]];
}

@end
