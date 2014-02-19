//
//  DayCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"
#import "DayToggleButton.h"

@interface DayCell : UITableViewCell

@property (nonatomic, weak) Day *day;

- (void)toggleDayProperty:(NSString *)key withIndex:(NSInteger)index;
- (BOOL)isDayProperty:(NSString *)key ofType:(NSInteger)index;
- (void)refreshControls;

@end