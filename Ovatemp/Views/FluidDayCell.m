//
//  FluidDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "FluidDayCell.h"

@implementation FluidDayCell

- (void)updateControls {
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

  self.stickyButton.selected = [self.day isProperty:@"cervicalFluid" ofType:CERVICAL_FLUID_STICKY];
  self.creamyButton.selected = [self.day isProperty:@"cervicalFluid" ofType:CERVICAL_FLUID_CREAMY];
  self.eggwhiteButton.selected = [self.day isProperty:@"cervicalFluid" ofType:CERVICAL_FLUID_EGGWHITE];

  self.dryButton.selected = [self.day isProperty:@"vaginalSensation" ofType:VAGINAL_SENSATION_DRY];
  self.wetButton.selected = [self.day isProperty:@"vaginalSensation" ofType:VAGINAL_SENSATION_WET];
  self.lubeButton.selected = [self.day isProperty:@"vaginalSensation" ofType:VAGINAL_SENSATION_LUBE];

  for(UIButton *button in @[self.stickyButton, self.creamyButton, self.eggwhiteButton]) {
    if(button.selected) {
      self.fluidImageView.image = [button imageForState:UIControlStateNormal];
    }
  }

  for(UIButton *button in @[self.dryButton, self.wetButton, self.lubeButton]) {
    if(button.selected) {
      self.sensationImageView.image = [button imageForState:UIControlStateNormal];
    }
  }
}

- (IBAction)stickyTapped:(id)sender {
  [self.day updateProperty:@"cervicalFluid" withIndex:CERVICAL_FLUID_STICKY];
  [self updateControls];
}

- (IBAction)creamyTapped:(id)sender {
  [self.day updateProperty:@"cervicalFluid" withIndex:CERVICAL_FLUID_CREAMY];
  [self updateControls];
}

- (IBAction)eggwhiteTapped:(id)sender {
  [self.day updateProperty:@"cervicalFluid" withIndex:CERVICAL_FLUID_EGGWHITE];
  [self updateControls];
}

- (IBAction)dryTapped:(id)sender {
  [self.day updateProperty:@"vaginalSensation" withIndex:VAGINAL_SENSATION_DRY];
  [self updateControls];
}

- (IBAction)wetTapped:(id)sender {
  [self.day updateProperty:@"vaginalSensation" withIndex:VAGINAL_SENSATION_WET];
  [self updateControls];
}

- (IBAction)lubeTapped:(id)sender {
  [self.day updateProperty:@"vaginalSensation" withIndex:VAGINAL_SENSATION_LUBE];
  [self updateControls];
}

- (void)initializeControls {
  [self.stickyButton setImage:[UIImage imageNamed:@"Sticky"] forState:UIControlStateNormal];
  [self.creamyButton    setImage:[UIImage imageNamed:@"Creamy"] forState:UIControlStateNormal];
  [self.eggwhiteButton   setImage:[UIImage imageNamed:@"Eggwhite"] forState:UIControlStateNormal];

  [self.dryButton   setImage:[UIImage imageNamed:@"Dry"] forState:UIControlStateNormal];
  [self.wetButton   setImage:[UIImage imageNamed:@"Wet"] forState:UIControlStateNormal];
  [self.lubeButton   setImage:[UIImage imageNamed:@"Lube"] forState:UIControlStateNormal];
}

@end
