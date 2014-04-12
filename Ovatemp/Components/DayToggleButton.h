//
//  DayToggleButton.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DayAttribute;

@interface DayToggleButton : UIButton

@property DayAttribute *attribute;
@property NSInteger choice;

@end
