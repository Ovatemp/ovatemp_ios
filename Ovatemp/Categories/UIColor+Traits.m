//
//  UIColor+Traits.m
//  Sweepon
//
//  Created by Flip Sasser on 3/6/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UIColor+Traits.h"

@implementation UIColor (Traits)

- (CGFloat)brightness {
  CGFloat hue, saturation, brightness, alpha;
  [self reliablyGetHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
  return brightness;
}

- (UIColor *)darkenBy:(CGFloat)amount {
  CGFloat hue, saturation, brightness, alpha;
  [self reliablyGetHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
  return [UIColor colorWithHue:hue saturation:saturation brightness:brightness - amount alpha:alpha];
}

- (void)reliablyGetHue:(CGFloat *)hue saturation:(CGFloat *)saturation brightness:(CGFloat *)brightness alpha:(CGFloat *)alpha {
  [self getHue:hue saturation:saturation brightness:brightness alpha:alpha];
  if (hue < 0 || saturation < 0 || brightness < 0 || alpha < 0) {
    CGFloat white;
    [self getWhite:&white alpha:alpha];
    if (white < 0 || alpha < 0) {
      // WUT
    }
    *hue = 0;
    *saturation = 0;
    *brightness = white;
  }
}

@end
