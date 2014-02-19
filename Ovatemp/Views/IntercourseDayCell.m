//
//  IntercourseDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "IntercourseDayCell.h"

@implementation IntercourseDayCell

- (void)refreshControls {
  if(self.day.intercourse) {
    self.intercourseLabel.text = [self.day.intercourse capitalizedString];
    self.intercourseImageView.hidden = FALSE;
  } else {
    self.intercourseImageView.hidden = TRUE;
    self.intercourseLabel.text = @"Swipe to edit";
  }

  for(DayToggleButton *button in @[self.unprotectedButton, self.protectedButton]) {
    [button refresh];

    if(button.selected) {
      self.intercourseImageView.image = [button imageForState:UIControlStateNormal];
    }
  }
}

- (void)initializeControls {
  [self.protectedButton      setImage:[UIImage imageNamed:@"Protected"] forState:UIControlStateNormal];
  [self.unprotectedButton    setImage:[UIImage imageNamed:@"Unprotected"] forState:UIControlStateNormal];

  [self.unprotectedButton setDayCell:self property:@"intercourse" index:INTERCOURSE_UNPROTECTED];
  [self.protectedButton   setDayCell:self property:@"intercourse" index:INTERCOURSE_PROTECTED];
}

@end