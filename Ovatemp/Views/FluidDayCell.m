//
//  FluidDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "FluidDayCell.h"

@implementation FluidDayCell

- (void)refreshControls {
  if(self.day.cervicalFluid) {
    self.fluidLabel.text = [self.day.cervicalFluid capitalizedString];
    self.fluidImageView.hidden = FALSE;
  } else {
    self.fluidLabel.text = @"Swipe to edit";
    self.fluidImageView.hidden = TRUE;
  }

  if(self.day.vaginalSensation) {
    self.sensationLabel.text = [self.day.vaginalSensation capitalizedString];
    self.sensationImageView.hidden = FALSE;
  } else {
    self.sensationLabel.text = @"Swipe to edit";
    self.sensationImageView.hidden = TRUE;
  }

  for(DayToggleButton *button in @[self.stickyButton, self.creamyButton, self.eggwhiteButton]) {
    [button refresh];
    if(button.selected) {
      self.fluidImageView.image = [button imageForState:UIControlStateNormal];
    }
  }

  for(DayToggleButton *button in @[self.dryButton, self.wetButton, self.lubeButton]) {
    [button refresh];
    if(button.selected) {
      self.sensationImageView.image = [button imageForState:UIControlStateNormal];
    }
  }
}

- (void)initializeControls {
  [self.stickyButton     setImage:[UIImage imageNamed:@"Sticky"] forState:UIControlStateNormal];
  [self.creamyButton     setImage:[UIImage imageNamed:@"Creamy"] forState:UIControlStateNormal];
  [self.eggwhiteButton   setImage:[UIImage imageNamed:@"Eggwhite"] forState:UIControlStateNormal];

  [self.stickyButton     setDayCell:self property:@"cervicalFluid" index:CERVICAL_FLUID_STICKY];
  [self.creamyButton     setDayCell:self property:@"cervicalFluid" index:CERVICAL_FLUID_CREAMY];
  [self.eggwhiteButton   setDayCell:self property:@"cervicalFluid" index:CERVICAL_FLUID_EGGWHITE];

  [self.dryButton    setImage:[UIImage imageNamed:@"Dry"] forState:UIControlStateNormal];
  [self.wetButton    setImage:[UIImage imageNamed:@"Wet"] forState:UIControlStateNormal];
  [self.lubeButton   setImage:[UIImage imageNamed:@"Lube"] forState:UIControlStateNormal];

  [self.dryButton   setDayCell:self property:@"vaginalSensation" index:VAGINAL_SENSATION_DRY];
  [self.wetButton   setDayCell:self property:@"vaginalSensation" index:VAGINAL_SENSATION_WET];
  [self.lubeButton  setDayCell:self property:@"vaginalSensation" index:VAGINAL_SENSATION_LUBE];
}

@end
