//
//  PeriodDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "PeriodDayCell.h"

@implementation PeriodDayCell

- (void)refreshControls {
  if(self.day.period) {
    self.periodLabel.text = [self.day.period capitalizedString];
    self.periodImageView.hidden = FALSE;
  } else {
    self.periodImageView.hidden = TRUE;
    self.periodLabel.text = @"Swipe to edit";
  }

  for(DayToggleButton *button in @[self.spottingButton, self.lightButton, self.mediumButton, self.heavyButton]) {
    [button refresh];
    if(button.selected) {
      self.periodImageView.image = [button imageForState:UIControlStateNormal];
    }
  }
}

- (void)initializeControls {
  [self.spottingButton setImage:[UIImage imageNamed:@"Spotting"] forState:UIControlStateNormal];
  [self.lightButton    setImage:[UIImage imageNamed:@"Light"] forState:UIControlStateNormal];
  [self.mediumButton   setImage:[UIImage imageNamed:@"Medium"] forState:UIControlStateNormal];
  [self.heavyButton    setImage:[UIImage imageNamed:@"Heavy"] forState:UIControlStateNormal];

  [self.spottingButton setDayCell:self property:@"period" index:PERIOD_SPOTTING];
  [self.lightButton setDayCell:self property:@"period" index:PERIOD_LIGHT];
  [self.mediumButton setDayCell:self property:@"period" index:PERIOD_MEDIUM];
  [self.heavyButton setDayCell:self property:@"period" index:PERIOD_HEAVY];
}

@end
