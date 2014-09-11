//
//  GradientSegmentedControl.m
//  Ovatemp
//
//  Created by Jason Welch on 9/4/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "GradientSegmentedControl.h"

@interface GradientSegmentedControl () {
  UIBezierPath *leftDividerPath;
  UIBezierPath *rightDividerPath;
}
@end

@implementation GradientSegmentedControl

// super draws a gradient button with a 1pt border
- (void)configureDefaults {
  [super configureDefaults];
  [self buildDividerLines];
}

// Divides the button into thirds with 2 vert lines
- (void)buildDividerLines {
  CGFloat x = self.bounds.size.width / 3;

  leftDividerPath = [self makeDividerWithXOrigin:x];
  rightDividerPath = [self makeDividerWithXOrigin:(x * 2)];
}

// Reused to draw the same sized line at whichever x starting point
- (UIBezierPath*) makeDividerWithXOrigin:(CGFloat)x {
  CGFloat length = (self.bounds.size.height - (self.borderWidth + 2.5));
  return [UIBezierPath bezierPathWithRect:CGRectMake(x, self.borderWidth + 0.5, 1.0f, length)];
}

// Allows the lines to blend into one solid block when pressed
- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  if (self.isHighlighted || self.isSelected) {
    [leftDividerPath fill];
    [rightDividerPath fill];
  } else {
    [leftDividerPath stroke];
    [rightDividerPath stroke];
  }
}

@end
