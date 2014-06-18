//
//  GradientSegmentedControlButton.m
//  Ovatemp
//
//  Created by Jason Welch on 9/15/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "GradientSegmentedControlButton.h"

@implementation GradientSegmentedControlButton

- (void)buildBorderPath {
  borderPath = [UIBezierPath bezierPathWithRect:self.bounds];
  borderPath.lineWidth = 0;
}

@end
