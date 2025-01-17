//
//  DayToggleButton.m
//  Ovatemp
//
//  Created by Chris Cahoon on 2/13/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "DayToggleButton.h"
#import "DayCell.h"
#import "QuartzCore/QuartzCore.h"

#define kDayToggleButtonTextPadding 4.0f

@interface DayToggleButton () {
}

@property (nonatomic, assign) NSInteger propValueIndex;
@property (nonatomic, weak) DayCell *dayCell;

@end

@implementation DayToggleButton

// This button currently has its image frame size hard coded, but that could be remedied
// Generally, you want to size the button so that it can fit everything you want (the label
// text and the icon). Since this is pretty rigid with the current Today screen, I haven't
// made it more dynamic or flexible yet.
- (void)layoutSubviews {
  [super layoutSubviews];

  self.imageView.layer.cornerRadius = 5.0f;
  self.imageView.layer.masksToBounds = TRUE;
  self.imageView.contentMode = UIViewContentModeCenter;

  // Move the image to the top and center it horizontally
  CGRect imageFrame = self.imageView.frame;
  imageFrame.size.width = 50;
  imageFrame.size.height = 50;
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

  if (self.selected) {
    self.imageView.backgroundColor = [UIColor whiteColor];
  } else {
    self.imageView.backgroundColor = [UIColor clearColor];
  }
}

@end
