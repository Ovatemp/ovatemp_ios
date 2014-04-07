//
//  RoundedButton.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "RoundedButton.h"

#import "UIColor+Traits.h"

@interface RoundedButton () {
  UIColor *_backgroundColor;
}

- (void)buildPaths;
- (void)setupDefaults;

@end

@implementation RoundedButton

@synthesize cornerRadius = _cornerRadius;

# pragma mark - Setup

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setupDefaults];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setupDefaults];
  }
  return self;
}

- (void)setupDefaults {
  self.clipsToBounds = NO;
  self.layer.shadowRadius = 0;
}

# pragma mark - Properties

- (UIColor *)backgroundColor {
  return _backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  _backgroundColor = backgroundColor;
  _borderColor = [backgroundColor darkenBy:0.2];

  if (backgroundColor.brightness >= 0.5f) {
    self.tintColor = DARK;
    self.titleLabel.textColor = DARK;
  } else {
    self.tintColor = LIGHT;
    self.titleLabel.textColor = LIGHT;
  }
}

# pragma mark - Drawing

- (void)buildPaths {
  self.layer.shadowRadius = 0;
  [self buildDefaultPath];
}

- (void)buildDefaultPath {
  _backgroundPath = [self pathForRect:self.bounds];
}

- (UIBezierPath *)pathForRect:(CGRect)rect {
  UIRectCorner corners = 0;
  if (!self.index) {
    corners |= UIRectCornerBottomLeft;
  }
  if (self.index == self.siblings - 1) {
    corners |= UIRectCornerBottomRight;
  }
  UIBezierPath *buttonPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
  return buttonPath;
}

# pragma mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  if (_backgroundColor) {
    if (!_backgroundPath) {
      [self buildPaths];
    }
    [_backgroundColor setFill];
    [_backgroundPath fill];
  }
}

@end
