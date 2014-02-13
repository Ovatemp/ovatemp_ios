//
//  PeriodDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "PeriodDayCell.h"

@implementation PeriodDayCell

- (void)setDay:(Day *)day {
  if(day.period) {
    self.periodLabel.text = [day.period capitalizedString];
  } else {
    self.periodLabel.text = @"Swipe to edit";
  }
}

@end
