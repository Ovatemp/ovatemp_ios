//
//  DayToggleButton.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DayToggleButton.h"
#import "QuartzCore/QuartzCore.h"

#define kDayToggleButtonTextPadding 10.0f

@implementation DayToggleButton

- (void)layoutSubviews {
  [super layoutSubviews];

  self.imageView.layer.cornerRadius = 5.0f;
  self.imageView.layer.masksToBounds = TRUE;
  self.imageView.contentMode = UIViewContentModeCenter;

  // Move the image to the top and center it horizontally
  CGRect imageFrame = self.imageView.frame;
  imageFrame.origin.y = 0;
  imageFrame.origin.x = (self.frame.size.width / 2) - (imageFrame.size.width / 2);
  self.imageView.frame = imageFrame;

  // Adjust the label size to fit the text, and move it below the image
  CGRect titleLabelFrame = self.titleLabel.frame;

  CGSize maximumLabelSize = CGSizeMake(310, 9999);
  self.titleLabel.numberOfLines = 0;
  CGSize labelSize = [self.titleLabel sizeThatFits:maximumLabelSize];

  titleLabelFrame.size = labelSize;
  titleLabelFrame.origin.x = (self.frame.size.width / 2) - (labelSize.width / 2);
  titleLabelFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + kDayToggleButtonTextPadding;
  self.titleLabel.frame = titleLabelFrame;
}


- (void)setSelected:(BOOL)selected {
  [super setSelected:selected];

  if(self.selected) {
    self.imageView.backgroundColor = [UIColor whiteColor];
  } else {
    self.imageView.backgroundColor = [UIColor clearColor];
  }
}

@end
