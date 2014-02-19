//
//  SignsDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SignsDayCell.h"

@implementation SignsDayCell

- (void)refreshControls {
  if(self.day.opk) {
    self.opkImageView.hidden = FALSE;
  } else {
    self.opkImageView.hidden = TRUE;
  }

  self.opkImageView.hidden = self.day.opk == nil;
  self.ferningImageView.hidden = self.day.ferning == nil;

  for(DayToggleButton *button in @[self.opkNegativeButton, self.opkPositiveButton]) {
    [button refresh];
    if(button.selected) {
      self.opkImageView.image = [button imageForState:UIControlStateNormal];
    }
  }

  for(DayToggleButton *button in @[self.ferningNegativeButton, self.ferningPositiveButton]) {
    [button refresh];
    if(button.selected) {
      self.ferningImageView.image = [button imageForState:UIControlStateNormal];
    }
  }
}

- (void)initializeControls {
  [self.opkNegativeButton setDayCell:self property:@"opk" index:OPK_NEGATIVE];
  [self.opkPositiveButton setDayCell:self property:@"opk" index:OPK_POSITIVE];
  [self.ferningNegativeButton setDayCell:self property:@"ferning" index:FERNING_NEGATIVE];
  [self.ferningPositiveButton setDayCell:self property:@"ferning" index:FERNING_POSITIVE];
}

@end
