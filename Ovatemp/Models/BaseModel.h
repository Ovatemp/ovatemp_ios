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

@property NSDate *createdAt;
@property NSDate *updatedAt;

@property (nonatomic, strong) NSSet *ignoredAttributes;

+ (NSMutableDictionary *)instances;
+ (BOOL)isLoaded;
+ (NSString *)key;
+ (void)resetInstances;
+ (id)withAttributes:(NSDictionary *)attributes;
- (void)setAttributes:(NSDictionary *)attributes;
- (NSDictionary *)attributes:(BOOL)camelCase;

@end
