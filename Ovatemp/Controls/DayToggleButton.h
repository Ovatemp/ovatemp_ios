//
//  DayToggleButton.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DayCell;

@interface DayToggleButton : UIButton

- (void)setDayCell:(DayCell *)dayCell property:(NSString *)key index:(NSInteger)index;
- (void)refresh;

@end
