//
//  BaseModel.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property NSNumber *id;
@property NSDictionary *attributes;

@property NSDate *createdAt;
@property NSDate *updatedAt;

+ (NSMutableDictionary *)instances;
+ (BOOL)isLoaded;
+ (NSString *)key;
+ (void)resetInstances;
+ (id)withAttributes:(NSDictionary *)attributes;

@end
