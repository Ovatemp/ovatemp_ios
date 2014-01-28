//
//  Constants.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <Foundation/Foundation.h>

UIColor * Color(int red, int green, int blue);
UIColor * HSB(CGFloat hue, CGFloat saturation, CGFloat brightness);
UIColor * Darken(UIColor *color, CGFloat amount);

#define DARK Color(56, 62, 62)
#define LIGHT Color(255, 255, 255)

#define LIGHT_BLUE Color(87, 198, 191)
#define BLUE Color(37, 152, 158)
#define DARK_BLUE Color(31, 108, 114)

#define PURPLE Color(124, 65, 160)