//
//  PeriodDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "PeriodDayCell.h"

@implementation PeriodDayCell

- (IBAction)spottingTapped:(id)sender {
  [self.day updateProperty:@"period" withIndex:PERIOD_SPOTTING];
  [self updateControls];
}

- (IBAction)lightTapped:(id)sender {
  [self.day updateProperty:@"period" withIndex:PERIOD_LIGHT];
  [self updateControls];
}

- (IBAction)mediumTapped:(id)sender {
  [self.day updateProperty:@"period" withIndex:PERIOD_MEDIUM];
  [self updateControls];
}

- (IBAction)heavyTapped:(id)sender {
  [self.day updateProperty:@"period" withIndex:PERIOD_HEAVY];
  [self updateControls];
}

- (void)updateControls {
  if(self.day.period) {
    self.periodLabel.text = [self.day.period capitalizedString];
  } else {
    self.periodLabel.text = @"Swipe to edit";
  }

  self.spottingButton.selected = [self.day isProperty:@"period" ofType:PERIOD_SPOTTING];
  self.lightButton.selected = [self.day isProperty:@"period" ofType:PERIOD_LIGHT];
  self.mediumButton.selected = [self.day isProperty:@"period" ofType:PERIOD_MEDIUM];
  self.heavyButton.selected = [self.day isProperty:@"period" ofType:PERIOD_HEAVY];
}

- (void)initializeControls {
  [self.spottingButton setImage:[UIImage imageNamed:@"Spotting"] forState:UIControlStateNormal];
  [self.lightButton    setImage:[UIImage imageNamed:@"Light"] forState:UIControlStateNormal];
  [self.mediumButton   setImage:[UIImage imageNamed:@"Medium"] forState:UIControlStateNormal];
  [self.heavyButton    setImage:[UIImage imageNamed:@"Heavy"] forState:UIControlStateNormal];
}

@end
