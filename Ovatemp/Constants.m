//
//  Constants.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Constants.h"

UIColor * Color(int red, int green, int blue) {
  return ColorA(red, green, blue, 1);
}

UIColor * ColorA(int red, int green, int blue, CGFloat alpha) {
  return [UIColor colorWithRed:red / 255.0f green:green / 255.0f blue:blue / 255.0f alpha:alpha];
}
