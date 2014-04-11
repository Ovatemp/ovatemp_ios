//
//  BorderedGradientButton.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BorderedGradientButton.h"

#import "UIColor+Traits.h"

@interface BorderedGradientButton () {
  UIBezierPath *borderPath;
  UIColor *gradient;
}
@end

@implementation BorderedGradientButton

@synthesize borderWidth = _borderWidth;
@synthesize cornerRadius = _cornerRadius;

# pragma mark - Setup

- (void)configureDefaults {
  [super configureDefaults];
  gradient = [UIColor gradientWithSize:self.bounds.size
                             fromColor:GRADIENT_BLUE
                         startPosition:CGPointZero
                               toColor:GRADIENT_PINK
                           endPosition:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
  if (!isnormal(self.cornerRadius)) {
    self.cornerRadius = 3.0f;
  }

  if (!isnormal(self.borderWidth)) {
    self.borderWidth = 1.0f;
  }
}

- (void)buildBorderPath {
  CGRect bounds = self.bounds;
  bounds = CGRectInset(bounds, self.borderWidth + 0.5, self.borderWidth + 0.5);
  borderPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.cornerRadius];
  borderPath.lineWidth = self.borderWidth;
}

- (CGFloat)borderWidth {
  return _borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  _borderWidth = borderWidth;
  [self buildBorderPath];
}

- (CGFloat)cornerRadius {
  return _cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  [self buildBorderPath];
}


# pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  if (active) {
    [gradient setFill];
    [borderPath fill];
  } else {
    [gradient setStroke];
    [borderPath stroke];
  }
}

- (void)setHighlightedTextColor {
  self.titleLabel.textColor = LIGHT;
}

@end
