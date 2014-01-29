//
//  BaseModel.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BaseModel.h"

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

@end
