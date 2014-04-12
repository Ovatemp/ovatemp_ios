//
//  DayAttribute.h
//  Ovatemp
//
//  Created by Flip Sasser on 4/11/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DayAttributeInterfaceType : NSInteger {
  DayAttributeToggle,
  DayAttributeList,
  DayAttributeCustom
} DayAttributeInterfaceType;

@interface DayAttribute : NSObject

+ (DayAttribute *)withName:(NSString *)name type:(DayAttributeInterfaceType)type;

@property Class choiceClass;
@property NSArray *choices;
@property NSString *name;
@property NSString *title;
@property DayAttributeInterfaceType type;

@end
