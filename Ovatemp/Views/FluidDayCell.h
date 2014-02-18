//
//  FluidDayCell.h
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DayCell.h"

@interface FluidDayCell : DayCell

@property (weak, nonatomic) IBOutlet UIImageView *fluidImageView;
@property (weak, nonatomic) IBOutlet UILabel *fluidLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sensationImageView;
@property (weak, nonatomic) IBOutlet UILabel *sensationLabel;

@property (weak, nonatomic) IBOutlet DayToggleButton *stickyButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *creamyButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *eggwhiteButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *dryButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *wetButton;
@property (weak, nonatomic) IBOutlet DayToggleButton *lubeButton;

@end
