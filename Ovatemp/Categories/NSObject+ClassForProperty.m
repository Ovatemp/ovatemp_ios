//
//  NSObject+ClassForProperty.m
//  Ovatemp
//
//  Created by Flip Sasser on 9/3/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "NSObject+ClassForProperty.h"
#import "RegexKitLite.h"

#import <objc/runtime.h>

static NSString * const kPropertyDescriptorObjCType = @"T@\"(.+)\"";

@implementation NSObject (ClassForProperty)

# pragma mark - Public interface

+ (Class)classForProperty:(NSString *)propertyName {
  NSString *className = [self objectiveCClassNameForProperty:propertyName];
  if (className) {
    return NSClassFromString(className);
  }

  return nil;
}

+ (NSString *)typeNameForKeyPath:(NSString *)keyPath {
  NSArray *keys = [keyPath componentsSeparatedByString:@"."];
  Class class = [self class];
  NSString *type = nil;
  for (NSString *key in keys) {
    NSString *propertyDescriptor = [class propertyDescriptorForProperty:key];
    if (!class) {
      NSLog(@"Cannot type properties of structs (specifically %@.%@)", type, key);
      return nil;
    }
    if (!propertyDescriptor) {
      NSLog(@"Cannot infer type of %@ (maybe it doesn't exist?)", keyPath);
      return nil;
    }
    type = [class objectiveCClassNameForPropertyDescriptor:propertyDescriptor];
    if (type) {
      class = [class classForProperty:key];
    } else {
      type = [class primitiveTypeNameForPropertyDescriptor:propertyDescriptor];
      class = nil;
    }
  }
  return type;
}

+ (NSString *)typeNameForProperty:(NSString *)propertyName {
  NSString *propertyDescriptor = [self propertyDescriptorForProperty:propertyName];
  NSString *className = [self objectiveCClassNameForPropertyDescriptor:propertyDescriptor];
  if (className) {
    return className;
  } else {
    return [self primitiveTypeNameForPropertyDescriptor:propertyDescriptor];
  }
  return nil;
}

- (Class)classForProperty:(NSString *)propertyName {
  return [[self class] classForProperty:propertyName];
}

- (NSString *)typeNameForKeyPath:(NSString *)keyPath {
  return [[self class] typeNameForKeyPath:keyPath];
}

- (NSString *)typeNameForProperty:(NSString *)propertyName {
  return [[self class] typeNameForProperty:propertyName];
}

# pragma mark - Helper methods

+ (NSString *)objectiveCClassNameForProperty:(NSString *)propertyName {
  NSString *propertyDescriptor = [self propertyDescriptorForProperty:propertyName];
  return [self objectiveCClassNameForPropertyDescriptor:propertyDescriptor];
}

+ (NSString *)objectiveCClassNameForPropertyDescriptor:(NSString *)propertyDescriptor {
  NSArray *matches = [propertyDescriptor captureComponentsMatchedByRegex:kPropertyDescriptorObjCType];
  if (matches.count == 2) {
    return matches[1];
  }
  return nil;
}

+ (NSString *)primitiveTypeNameForPropertyDescriptor:(NSString *)propertyDescriptor {
  NSArray *attributes = [propertyDescriptor componentsSeparatedByString:@","];
  NSString *type = attributes[0];
  const char *cType = type.UTF8String;

  if (strcmp(cType, @encode(float)) == 0) {
    return @"float";
  } else if (strcmp(cType, @encode(int)) == 0) {
    return @"int";
  } else if (strcmp(cType, @encode(id)) == 0) {
    return @"id";
  } else if (strcmp(cType, @encode(BOOL)) == 0 || strcmp(cType, @encode(char))) {
    return @"BOOL";
  }
  NSLog(@"Couldn't type %@", propertyDescriptor);
  return nil;
}

+ (NSString *)propertyDescriptorForProperty:(NSString *)propertyName {
  objc_property_t property = class_getProperty([self class], propertyName.UTF8String);
  if (property) {
    const char *attributes = property_getAttributes(property);
    if (attributes) {
      return [NSString stringWithUTF8String:attributes];
    }
  }
  return nil;
}

@end
