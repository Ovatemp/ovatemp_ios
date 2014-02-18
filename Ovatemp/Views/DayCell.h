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

@end