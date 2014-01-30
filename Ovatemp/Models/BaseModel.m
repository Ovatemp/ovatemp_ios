//
//  BaseModel.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

static NSMutableDictionary *_instances;

@interface BaseModel () {
  NSMutableDictionary *_attributes;
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

+ (BOOL)isLoaded {
  return [self.instances count] > 0;
}

+ (NSString *)key {
  return @"id";
}

+ (void)resetInstances {
  [_instances removeObjectForKey:NSStringFromClass([self class])];
}

+ (id)withAttributes:(NSDictionary *)attributes {
  NSString *classPrefix = [self description];
  NSString *key = [attributes objectForKey:self.key];
  NSString *instanceLocator = [NSString stringWithFormat:@"%@:%@", classPrefix, key];
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

#pragma mark - Key value storage

- (NSDictionary *)attributes {
  return [NSDictionary dictionaryWithDictionary:_attributes];
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

- (void)setAttributes:(NSDictionary *)attributes {
  if (!_attributes) {
    _attributes = [NSMutableDictionary dictionary];
  }

  [_attributes addEntriesFromDictionary:attributes];

  for (NSString *snakeKey in attributes) {
    id value = [attributes objectForKey:snakeKey];

    NSString *camelKey = [self camelCase:snakeKey];
    camelKey = [camelKey stringByReplacingOccurrencesOfString:@"Url" withString:@"URL"];

    [self setValue:value forKey:camelKey];
  }
}

- (void)setValue:(id)value forKey:(NSString *)key {
  if ([value isEqual:[NSNull null]]) {
    [super setValue:nil forKey:key];
  } else {
    NSString *className = [self classForKey:key];
    if ([className rangeOfString:@"NSDate"].location != NSNotFound) {
      value = [self dateForValue:value];
    }
    [super setValue:value forKey:key];
  }
}

- (NSString *)classForKey:(NSString *)key {
  objc_property_t property = class_getProperty([self class], [key UTF8String]);
  if (property != NULL) {
    const char *attributes = property_getAttributes(property);
    if (attributes != NULL) {
      static char buffer[256];
      const char *e = strchr(attributes, ',');
      if (e != NULL) {
        int len = (int)(e - attributes);
        memcpy(buffer, attributes, len);
        buffer[len] = '\0';
        return [NSString stringWithUTF8String:buffer];
      }
    }
  }
  return nil;
}

- (NSDate *)dateForValue:(id)value {
  if ([value isKindOfClass:[NSString class]]) {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZ";
    return [dateFormatter dateFromString:value];
  }
  return value;
}

@end
