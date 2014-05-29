//
//  NSObject+ClassForProperty.h
//  Ovatemp
//
//  Created by Flip Sasser on 9/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ClassForProperty)

+ (Class)classForProperty:(NSString *)propertyName;
+ (NSString *)typeNameForProperty:(NSString *)propertyName;
+ (NSString *)typeNameForKeyPath:(NSString *)keyPath;

- (Class)classForProperty:(NSString *)propertyName;
- (NSString *)typeNameForProperty:(NSString *)propertyName;
- (NSString *)typeNameForKeyPath:(NSString *)keyPath;

@end
