//
//  PeriodDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "PeriodDayCell.h"

@implementation PeriodDayCell

@synthesize day = _day;

- (void)setDay:(Day *)day {
  if(day.period) {
    self.periodLabel.text = [day.period capitalizedString];
  } else {
    self.periodLabel.text = @"Swipe to edit";
  }

  _day = day;

  [self updateButtons];
}

- (IBAction)spottingTapped:(id)sender {
  [self.day updateProperty:@"period" withIndex:PERIOD_SPOTTING];
  [self updateButtons];
}

- (IBAction)lightTapped:(id)sender {
  [self.day updateProperty:@"period" withIndex:PERIOD_LIGHT];
  [self updateButtons];
}

- (IBAction)mediumTapped:(id)sender {
  [self.day updateProperty:@"period" withIndex:PERIOD_MEDIUM];
  [self updateButtons];
}

- (IBAction)heavyTapped:(id)sender {
  [self.day updateProperty:@"period" withIndex:PERIOD_HEAVY];
  [self updateButtons];
}

- (void)updateButtons {
  self.spottingButton.selected = [self.day isProperty:@"period" ofType:PERIOD_SPOTTING];
  self.lightButton.selected = [self.day isProperty:@"period" ofType:PERIOD_LIGHT];
  self.mediumButton.selected = [self.day isProperty:@"period" ofType:PERIOD_MEDIUM];
  self.heavyButton.selected = [self.day isProperty:@"period" ofType:PERIOD_HEAVY];
}

@end
