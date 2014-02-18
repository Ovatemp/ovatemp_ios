//
//  SignsDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "SignsDayCell.h"

@implementation SignsDayCell

- (void)updateControls {
  if(self.day.opk) {
    self.opkImageView.hidden = FALSE;
  } else {
    self.opkImageView.hidden = TRUE;
  }

  self.opkImageView.hidden = self.day.opk == nil;
  self.ferningImageView.hidden = self.day.ferning == nil;

  self.opkNegativeButton.selected = [self.day isProperty:@"opk" ofType:OPK_NEGATIVE];
  self.opkPositiveButton.selected = [self.day isProperty:@"opk" ofType:OPK_POSITIVE];

  self.ferningNegativeButton.selected = [self.day isProperty:@"ferning" ofType:FERNING_NEGATIVE];
  self.ferningPositiveButton.selected = [self.day isProperty:@"ferning" ofType:FERNING_POSITIVE];

  for(UIButton *button in @[self.opkNegativeButton, self.opkPositiveButton]) {
    if(button.selected) {
      self.opkImageView.image = [button imageForState:UIControlStateNormal];
    }
  }

  for(UIButton *button in @[self.ferningNegativeButton, self.ferningPositiveButton]) {
    if(button.selected) {
      self.ferningImageView.image = [button imageForState:UIControlStateNormal];
    }
  }
}

- (void)initializeControls {
  // noop
}

- (IBAction)negativeOpkTapped:(id)sender {
  [self.day updateProperty:@"opk" withIndex:OPK_NEGATIVE];
  [self updateControls];
}

- (IBAction)positiveOpkTapped:(id)sender {
  [self.day updateProperty:@"opk" withIndex:OPK_POSITIVE];
  [self updateControls];
}

- (IBAction)negativeFerningTapped:(id)sender {
  [self.day updateProperty:@"ferning" withIndex:FERNING_NEGATIVE];
  [self updateControls];
}

- (IBAction)positiveFerningTapped:(id)sender {
  [self.day updateProperty:@"ferning" withIndex:FERNING_POSITIVE];
  [self updateControls];
}

@end
