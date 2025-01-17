// I am that I am Ovatemp. The app that brought FAM to all women in the world.
// Om navah shivaya.
//
//  Constants.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "Configuration.h"

// Set this if you want your build to use the staging server
//#define BETA 1

// Color definitions; arguments are: red, green, blue
#define DARK Color(56, 62, 62)
#define LIGHT Color(255, 255, 255)

#define BLUE Color(37, 152, 158)
#define LIGHT_BLUE Color(87, 198, 191)
#define DARK_BLUE Color(31, 108, 114)

#define GREEN Color(56, 192, 191)
#define LIGHT_GREEN Color(103, 230, 223)
#define DARK_GREEN Color(16, 115, 136)

#define GREY Color(42, 109, 131)
#define LIGHT_GREY Color(214, 214, 214)

#define COMMUNITY_BLUE Color(16, 85, 120)

#define PURPLE Color(124, 66, 160)

#define GRADIENT_BLUE Color(53, 18, 215)
#define GRADIENT_PINK Color(249, 0, 91)

#define FERTILITY_WINDOW_COLOR ColorA(56, 192, 191, 0.16)

// API configuration
#if TARGET_IPHONE_SIMULATOR
  #define ROOT_URL @"http://localhost:3000"
  #define DEVICE_ID @"DUMMYDEVICE"
#else
  #ifdef RELEASE_AUTOMATION
    #define ROOT_URL @"http://ovatemp-api-staging.herokuapp.com"
  #else
    #define ROOT_URL @"http://api.ovatemp.com"
  #endif

  #define DEVICE_ID [UIDevice currentDevice].identifierForVendor.UUIDString
#endif

# define API_URL [ROOT_URL stringByAppendingString:@"/api"]

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

// In app purchase config

#define IAP_SHARED_SECRET @"e5a5438524c64f7db49fb672bd5ab9a7"

// 3rd party API keys
static NSString * const kGoogleAnalyticsTrackingID = @"UA-32219902-2";
static NSString * const kGoogleAdwordsConversionID = @"1009399358";
static NSString * const kGoogleAdwordsConversionLabel = @"Xn3pCKKe1gcQvuyo4QM";
static NSString * const kHockeyIdentifier = @"6e19f3154c79a220e01f3820bf0f0f06";
static NSString * const kMixpanelToken = @"fc5f08cf07825041f4741d2c20860f54";
