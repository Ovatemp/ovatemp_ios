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

#define BLUE Color(37, 152, 158)
#define LIGHT_BLUE Color(87, 198, 191)
#define DARK_BLUE Color(31, 108, 114)

#define GREEN Color(133, 244, 221)
#define LIGHT_GREEN Color(103, 230, 223)
#define DARK_GREEN Color(16, 115, 136)

#define GREY Color(42, 109, 131)
#define LIGHT_GREY Color(214, 214, 214)
#define DARK_GREY Color(56, 62, 62)

#define COMMUNITY_BLUE Color(16, 85, 120)

#define PURPLE Color(124, 66, 160)

#define GRADIENT_BLUE Color(53, 18, 215)
#define GRADIENT_PINK Color(249, 0, 91)

#define FERTILITY_WINDOW_COLOR ColorA(56, 192, 191, 0.16)

// API configuration
#if TARGET_IPHONE_SIMULATOR
#define API_URL @"http://localhost:3000/api"
#define DEVICE_ID @"DUMMYDEVICE"
#else
#define API_URL @"http://ovatemp-rails-staging.herokuapp.com/api"
#define DEVICE_ID [UIDevice currentDevice].identifierForVendor.UUIDString
#endif

static NSInteger const kUnauthorizedRequestCode = 401;
static NSString * const kUnauthorizedRequestNotification = @"401UnauthorizedRequestEncountered";

// UI configuration
// The are Apple's standard spacing defaults. Don't change
// these unless the defaults change!
static const CGFloat SIBLING_SPACING = 8.0f;
static const CGFloat SUPERVIEW_SPACING = 20.0f;

UIColor * Color(int red, int green, int blue);
UIColor * ColorA(int red, int green, int blue, CGFloat alpha);

#define STATUS_BAR_HEIGHT 20

// 3rd party API keys
static NSString * const kGoogleAnalyticsTrackingID = @"UA-32219902-1";
static NSString * const kGoogleAdwordsConversionID = @"1009399358";
static NSString * const kGoogleAdwordsConversionLabel = @"Xn3pCKKe1gcQvuyo4QM";

