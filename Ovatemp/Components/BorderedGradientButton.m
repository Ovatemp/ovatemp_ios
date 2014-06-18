//
//  BorderedGradientButton.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/7/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "BorderedGradientButton.h"

@interface BorderedGradientButton () {
  CGFloat _borderWidth;
  CGFloat _cornerRadius;
  UIColor *gradient;
}
@end

@implementation BorderedGradientButton

# pragma mark - Setup

- (void)configureDefaults {
  [super configureDefaults];
  if (!CGRectEqualToRect(self.bounds, CGRectZero)) {
    gradient = [UIColor gradientWithSize:self.bounds.size
                               fromColor:GRADIENT_BLUE
                           startPosition:CGPointZero
                                 toColor:GRADIENT_PINK
                             endPosition:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [self buildBorderPath];
  }
}

- (void)buildBorderPath {
  CGRect bounds = self.bounds;
  bounds = CGRectInset(bounds, self.borderWidth + 0.5, self.borderWidth + 0.5);
  borderPath = [UIBezierPath bezierPathWithRoundedRect:bounds cornerRadius:self.cornerRadius];
  borderPath.lineWidth = self.borderWidth;
}

- (CGFloat)borderWidth {
  if (!isnormal(_borderWidth)) {
    return 1.0f;
  } else {
    return _borderWidth;
  }
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  _borderWidth = borderWidth;
  [self buildBorderPath];
}

- (CGFloat)cornerRadius {
  if (!isnormal(_cornerRadius)) {
    return 3.0f;
  } else {
    return _cornerRadius;
  }
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  [self buildBorderPath];
}

- (void)setHighlighted:(BOOL)highlighted {
  [super setHighlighted:highlighted];
  [self setNeedsDisplay];
}

- (void)setHighlightedTextColor {
  [self setTitleColor:LIGHT forState:UIControlStateHighlighted];
  [self setTitleColor:LIGHT forState:UIControlStateSelected];
}

# pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  if (self.isHighlighted || self.isSelected) {
    [gradient setFill];
    [borderPath fill];
  } else {
    [gradient setStroke];
    [borderPath stroke];
  }
}

@end
