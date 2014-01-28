//
//  Constants.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Constants.h"

UIColor * Color(int red, int green, int blue) {
  return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:1];
}

UIColor * Darken(UIColor *color, CGFloat amount) {
  CGFloat hue, saturation, brightness, alpha;
  [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
  return [UIColor colorWithHue:hue saturation:saturation brightness:brightness - amount alpha:1];
}