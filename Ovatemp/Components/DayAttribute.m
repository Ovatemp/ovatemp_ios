//
//  DayAttribute.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DayAttribute.h"

@interface DayAttribute () {
  NSString *_imageName;
  NSString *_title;
}
@end

@implementation DayAttribute

+ (DayAttribute *)withName:(NSString *)name type:(DayAttributeInterfaceType)type {
  DayAttribute *attribute = [[self alloc] init];
  attribute.name = name;
  attribute.type = type;
  return attribute;
}

- (NSString *)imageName {
  if (!_imageName) {
    return self.name.capitalizedString;
  }
  return _imageName;
}

- (void)setImageName:(NSString *)imageName {
  _imageName = imageName;
}

- (NSString *)title {
  if (!_title) {
    return self.name.capitalizedString;
  }
  return _title;
}

- (void)setTitle:(NSString *)title {
  _title = title;
}

@end
