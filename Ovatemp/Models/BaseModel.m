//
//  BaseModel.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BaseModel.h"
#import "NSObject+ClassForProperty.h"

static __strong NSMutableDictionary *_instances;

@interface BaseModel () {
  NSMutableDictionary *_serializedKeys;
}
@end

@implementation BaseModel

#pragma mark - Instance tracking

+ (NSMutableDictionary *)instances {
  if (!_instances) {
    _instances = [NSMutableDictionary dictionary];
  }
  NSString *className = NSStringFromClass([self class]);
  if (!_instances[className]) {
    _instances[className] = [NSMutableDictionary dictionary];
  }
  return _instances[className];
}

+ (NSArray *)all {
  NSMutableDictionary *instances = [self instances];
  NSMutableArray *all = [[NSMutableArray alloc] initWithCapacity:instances.count];

  for(id instance in instances) {
    [all addObject:instances[instance]];
  }

  return all;
}

+ (BOOL)isLoaded {
  return [self.instances count] > 0;
}

+ (NSString *)key {
  return @"id";
}

+ (void)resetInstances {
  [_instances removeObjectForKey:NSStringFromClass([self class])];
}

+ (void)resetInstancesWithArray:(NSArray *)array {
  if(!array) {
    return;
  }

  [self resetInstances];

  for(NSDictionary *instance in array) {
    [self withAttributes:instance];
  }
}

+ (id)withAttributes:(NSDictionary *)attributes {
  NSString *classPrefix = [self description];
  NSString *identifier = [attributes objectForKey:self.key];
  NSString *instanceLocator = [NSString stringWithFormat:@"%@:%@", classPrefix, identifier];
  BaseModel *instance = [self.instances objectForKey:instanceLocator];
  if (instance) {
    instance.attributes = attributes;
  } else {
    instance = [[self alloc] init];
    instance.attributes = attributes;
    [self.instances setObject:instance forKey:instanceLocator];
  }
  return instance;
}

+ (id)findByKey:(NSString *)identifier {
  NSString *classPrefix = [self description];
  NSString *instanceLocator = [NSString stringWithFormat:@"%@:%@", classPrefix, identifier];

  return [self.instances objectForKey:instanceLocator];
}

#pragma mark - Key value storage

- (NSDictionary *)attributesCamelCased:(BOOL)camelCase {
  return [self attributesForKeys:[NSSet setWithArray:[_serializedKeys allKeys]] camelCase:camelCase];
}

- (NSDictionary *)attributesForKeys:(NSSet *)keys camelCase:(BOOL)camelCase {
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

  for(NSString *key in keys) {
    id value = [self valueForKey:key];
    if(value == nil) {
      value = [NSNull null];
    }

    NSString *actualKey = key;
    if (!camelCase && _serializedKeys[key]) {
      actualKey = _serializedKeys[key];
    }

    if (actualKey) {
      attributes[actualKey] = value;
    } else {
      NSLog(@"%@ can't be serialized in %@", key, _serializedKeys);
    }
  }

  return attributes;
}

- (NSString *)camelCase:(NSString *)string {
  NSMutableString *camelString = [NSMutableString string];
  BOOL nextCharacterUppercase = NO;
  for (NSInteger i = 0; i < string.length; i++) {
    unichar character = [string characterAtIndex:i];
    if (character == '_') {
      nextCharacterUppercase = YES;
    } else if (nextCharacterUppercase) {
      nextCharacterUppercase = NO;
      [camelString appendString:[NSString stringWithCharacters:&character length:1].uppercaseString];
    } else {
      [camelString appendString:[NSString stringWithCharacters:&character length:1]];
    }
  }
  return camelString;
}

- (BOOL)shouldIgnoreKey:(NSString *)key {
  return self.ignoredAttributes && [self.ignoredAttributes member:key];
}

- (void)setAttributes:(NSDictionary *)attributes {
  if (!_serializedKeys) {
    _serializedKeys = [NSMutableDictionary dictionary];
  }

  for (NSString *snakeKey in attributes) {
    NSString *camelKey = [self camelCase:snakeKey];
    camelKey = [camelKey stringByReplacingOccurrencesOfString:@"Url" withString:@"URL"];

    if([self shouldIgnoreKey:camelKey]) continue;

    _serializedKeys[camelKey] = snakeKey;

    id value = [attributes objectForKey:snakeKey];
    [self setValue:value forKey:camelKey];
  }
}

- (void)setValue:(id)value forKey:(NSString *)key {
  if([self shouldIgnoreKey:key]) return;

  NSString *className = [self typeNameForKeyPath:key];
  if ([value isEqual:[NSNull null]]) {
    if ([className isEqualToString:@"BOOL"]) {
      value = @(NO);
    } else {
      return [super setValue:nil forKey:key];
    }
  } else if ([className rangeOfString:@"NSDate"].location != NSNotFound) {
    value = [self dateForValue:value];
  } else if ([className rangeOfString:@"NSMutableArray"].location != NSNotFound) {
    value = [value mutableCopy];
  }
  [super setValue:value forKey:key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  if([self shouldIgnoreKey:key]) return;
}

- (NSDate *)dateForValue:(id)value {
  if ([value isKindOfClass:[NSString class]]) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if([value length] > 10) {
      dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'";
    } else {
      dateFormatter.dateFormat = @"yyyy'-'MM'-'dd";
    }
    return [dateFormatter dateFromString:value];
  }
  return value;
}

@end
