//
//  Constants.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Configuration.h"

// Color definitions; arguments are: red, green, blue
#define DARK Color(56, 62, 62)
#define LIGHT Color(255, 255, 255)

#define LIGHT_BLUE Color(87, 198, 191)
#define BLUE Color(37, 152, 158)
#define DARK_BLUE Color(31, 108, 114)

#define PURPLE Color(124, 65, 160)

// API configuration
#ifdef DEBUG
#define API_URL @"http://localhost:3000/api"
#else
#define API_URL @"http://ovatemp-rails-staging.herokuapp.com/api"
#endif

#define DEVICE_ID [UIDevice currentDevice].identifierForVendor.UUIDString

// The are Apple's standard spacing defaults. Don't change
// these unless the defaults change!
#define SIBLING_SPACING 8.0f
#define SUPERVIEW_SPACING 20.0f

UIColor * Color(int red, int green, int blue);
UIColor * Darken(UIColor *color, CGFloat amount);

#define DELAY_BEFORE_SAVE 2