//
//  DisturbanceCellEditView.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DisturbanceCellEditView.h"

@interface DisturbanceCellEditView ()

@property UILabel *disturbanceLabel;
@property UISwitch *disturbanceSwitch;

@end

@implementation DisturbanceCellEditView

- (CGRect)buildCustomUI:(CGRect)frame {
  UILabel *disturbanceLabel = [[UILabel alloc] init];
  disturbanceLabel.font = [UIFont systemFontOfSize:11.0f];
  disturbanceLabel.text = @"Disturbance:";
  disturbanceLabel.textColor = LIGHT;
  [disturbanceLabel sizeToFit];
  CGRect disturbanceLabelFrame = disturbanceLabel.frame;
  disturbanceLabelFrame.origin.x = SUPERVIEW_SPACING;
  disturbanceLabel.frame = disturbanceLabelFrame;
  [self addSubview:disturbanceLabel];
  self.disturbanceLabel = disturbanceLabel;
  
  UISwitch *disturbanceSwitch = [[UISwitch alloc] init];
  [disturbanceSwitch sizeToFit];
  CGRect disturbanceSwitchFrame = disturbanceSwitch.frame;
  disturbanceSwitchFrame.origin.x = CGRectGetMaxX(disturbanceLabelFrame) + SIBLING_SPACING;
  disturbanceSwitchFrame.size.width = frame.size.width - SUPERVIEW_SPACING * 2;
  disturbanceSwitchFrame.origin.y = 0;
  disturbanceSwitch.frame = disturbanceSwitchFrame;
  [disturbanceSwitch addTarget:self action:@selector(updateDisturbance:) forControlEvents:UIControlEventValueChanged];
  [self addSubview:disturbanceSwitch];
  self.disturbanceSwitch = disturbanceSwitch;

  disturbanceLabelFrame.origin.y = (disturbanceSwitchFrame.size.height - disturbanceLabelFrame.size.height) / 2;
  self.disturbanceLabel.frame = disturbanceLabelFrame;
  
  frame.size.height = CGRectGetMaxY(disturbanceSwitch.frame) + SUPERVIEW_SPACING;
  return frame;
}

- (void)setValue:(id)value {
  self.disturbanceSwitch.on = [value boolValue];
}

- (void)updateDisturbance:(id)sender {
  [self.delegate attributeValueChanged:self.attribute newValue:@(self.disturbanceSwitch.on)];
}

@end
