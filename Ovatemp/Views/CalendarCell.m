//
//  CalendarCell.m
//  Ovatemp
//
//  Created by Chris Cahoon on 3/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "CalendarCell.h"

@interface CalendarCell () {
  UIColor *_originalBackgroundColor;
  UIColor *_originalDateBackgroundColor;
  UIColor *_originalDateTextColor;
  UIColor *_originalMonthTextColor;
  UIImage *_originalImage;
}

@end

@implementation CalendarCell

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  [self highlight];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  [self unhighlight];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  [self unhighlight];
}

- (void)highlight {
  _originalBackgroundColor = self.backgroundColor;
  self.backgroundColor = DARK;

  _originalDateTextColor = self.dateLabel.textColor;

  if (self.dateLabel.backgroundColor != [UIColor clearColor]) {
    _originalDateBackgroundColor = self.dateLabel.backgroundColor;
    self.dateLabel.backgroundColor = LIGHT;
    self.dateLabel.textColor = DARK;
  } else {
    self.dateLabel.textColor = LIGHT;
  }

  _originalMonthTextColor = self.monthLabel.textColor;
  self.monthLabel.textColor = LIGHT;

  _originalImage = self.imageView.image;
  self.imageView.image = [_originalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.imageView.tintColor = LIGHT;
}

- (void)unhighlight {
  self.backgroundColor = _originalBackgroundColor;
  _originalBackgroundColor = nil;

  if (_originalDateBackgroundColor) {
    self.dateLabel.backgroundColor = _originalDateBackgroundColor;
    _originalDateBackgroundColor = nil;
  }

  self.dateLabel.textColor = _originalDateTextColor;
  _originalDateTextColor = nil;

  self.monthLabel.textColor = _originalMonthTextColor;
  _originalMonthTextColor = nil;

  self.imageView.image = _originalImage;
  self.imageView.tintColor = nil;
  _originalImage = nil;
}

@end
