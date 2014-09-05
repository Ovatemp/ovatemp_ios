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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureDefaults {
  [super configureDefaults];
  [self buildDividerLines];
}

- (void)buildDividerLines {
//  CGFloat x = self.bounds.size.width / 3;
//  CGPoint startPoint = CGPointMake(x, 0);
//  CGPoint endPoint = CGPointMake(x, self.bounds.size.height);
//
//  CGContextRef cxt = UIGraphicsGetCurrentContext();
//  CGContextMoveToPoint(cxt, startPoint.x, startPoint.y);
//  CGContextAddLineToPoint(cxt, endPoint.x, endPoint.y);
//  CGContextStrokePath(cxt);
//
//  x += x;
//  startPoint = CGPointMake(x, 0);
//  endPoint = CGPointMake(x, self.bounds.size.height);
//
//  CGContextMoveToPoint(cxt, startPoint.x, startPoint.y);
//  CGContextAddLineToPoint(cxt, endPoint.x, endPoint.y);
//  CGContextStrokePath(cxt);

  // OR...

  CGFloat x = self.bounds.size.width / 3;

  leftDividerPath = [self makeDividerWithXOrigin:x];
  rightDividerPath = [self makeDividerWithXOrigin:(x * 2)];
}

- (UIBezierPath*) makeDividerWithXOrigin:(CGFloat)x {

  CGFloat length = (self.bounds.size.height - (self.borderWidth + 2.5));
  NSLog(@"Bounds height is %f and the set length is %f", self.bounds.size.height, length);
  return [UIBezierPath bezierPathWithRect:CGRectMake(x, self.borderWidth + 0.5, 1.0f, length)];
}

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
