//
//  PeriodDayCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayCell.h"
#import "DayToggleButton.h"

@interface PeriodDayCell : DayCell

@property (weak, nonatomic) IBOutlet UIImageView *periodImage;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

@property (weak, nonatomic) IBOutlet DayToggleButton *spottingButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *lightButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *mediumButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *heavyButton;

@end
