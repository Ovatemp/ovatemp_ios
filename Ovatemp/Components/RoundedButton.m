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
  UIBezierPath *_backgroundPath;
}

@end

@implementation RoundedButton

@synthesize cornerRadius = _cornerRadius;

# pragma mark - Setup

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self buildPath];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self buildPath];
  }
  return self;
}

# pragma mark - Properties

- (UIColor *)backgroundColor {
  return _backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
  _backgroundColor = backgroundColor;
  [self buildPath];
}

# pragma mark - Drawing

- (void)buildPath {
  CGRect bounds = self.bounds;
  bounds.origin.x += 0.5;
  bounds.origin.y += 0.5;
  bounds.size.height -= 1;
  bounds.size.width -= 1;

  // Build the path
  UIRectCorner corners = 0;
  if (!self.index) {
    corners |= UIRectCornerBottomLeft;
  }
  if (self.index == self.siblings - 1) {
    corners |= UIRectCornerBottomRight;
  }

  _backgroundPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                          byRoundingCorners:corners
                                                cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
  _backgroundPath.lineWidth = 1.0;
}

# pragma mark - Drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  [_backgroundColor setStroke];
  [_backgroundPath stroke];
}

@end
