//
//  TemperatureDayCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "TemperatureDayCell.h"

@implementation TemperatureDayCell

- (IBAction)sliderChanged:(id)sender {
  NSLog(@"slider changed: %f", self.slider.value);
  [self.day updateProperty:@"temperature" withValue:[NSNumber numberWithFloat:self.slider.value]];
  [self refreshControls];
}

- (IBAction)setTemperaturePressed:(id)sender {
  [self.day updateProperty:@"temperature" withValue:[NSNumber numberWithFloat:98.6]];
  [self refreshControls];
}

- (IBAction)disturbanceToggled:(UISwitch *)sender {
  self.day.disturbance = sender.on;
}

- (void)refreshControls {
  BOOL temperatureSet = (self.day.temperature != nil);
  self.slider.hidden = !temperatureSet;
  self.temperatureLabel.hidden = !temperatureSet;
  self.editTemperatureLabel.hidden = !temperatureSet;
  self.setTemperatureButton.hidden = temperatureSet;
  
  NSString *temperatureString = [NSString stringWithFormat:@"%.1fºF", [self.day.temperature floatValue]];
  self.temperatureLabel.text = temperatureString;
  self.editTemperatureLabel.text = temperatureString;
  self.slider.value = [self.day.temperature floatValue];

  self.disturbanceSwitch.on = self.day.disturbance;
}

- (void)initializeControls {
  self.slider.minimumValue = 95.0;
  self.slider.maximumValue = 105.0;
}

@end