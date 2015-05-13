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

#import <CocoaLumberjack/CocoaLumberjack.h>

// Set this if you want your build to use the staging server
//#define BETA 1

// COLORS
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

#define PERIOD_COLOR Color(253,84,84)

// COCOALUMBERJACK (Logging)

#ifdef STAGING_DEBUG
    static const DDLogLevel ddLogLeve = DDLogLevelAll;
#elif PRODUCTION_DEBUG
    static const DDLogLevel ddLogLeve = DDLogLevelAll;
#else
    static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif

// API

#define ROOT_URL @"http://api.ovatemp.com"
#define DEVICE_ID [UIDevice currentDevice].identifierForVendor.UUIDString

//#ifdef STAGING_DEBUG
//    #define ROOT_URL @"http://ovatemp-api-staging.herokuapp.com"
//
//#elif STAGING_RELEASE
//    #define ROOT_URL @"http://ovatemp-api-staging.herokuapp.com"
//
//#elif PRODUCTION_DEBUG
//    #define ROOT_URL @"http://api.ovatemp.com"
//
//#elif PRODUCTION_RELEASE
//    #define ROOT_URL @"http://api.ovatemp.com"
//
//#endif
//
//#ifdef TARGET_IPHONE_SIMULATOR
//    #define DEVICE_ID @"DUMMYDEVICE"
//#else
//    #define DEVICE_ID [UIDevice currentDevice].identifierForVendor.UUIDString
//#endif

# define API_URL [ROOT_URL stringByAppendingString:@"/api"]

static NSString *const kStripePublishableKey = @"pk_live_h36Hwh93e0s4kbukCJkC3ZKW"; // Live || Test

static NSString *const kAppGroupName = @"group.com.ovatemp.ovatemp";
static NSString *const kSharedTokenKey = @"CurrentUserToken";
static NSString *const kSharedDeviceIdKey = @"CurrentUserDeviceId";
static NSString *const kSharedUserTypeKey = @"SharedUserTypeKey";

static NSString *const kOndoOverlayCountKey = @"OndoOverlayCountKey";
static NSString *const kAppTutorialCountKey = @"AppTutorialCountKey";
static NSString *const kAppWalkthroughCountKey = @"AppWalkthroughCountKey";
static NSString *const kOndoTutorialCountKey = @"OndoTutorialCountKey";

static NSString *const kUserDidLogoutNotification = @"UserDidLogoutNotification";

static const NSInteger kUnauthorizedRequestCode = 401;
static NSString *const kUnauthorizedRequestNotification = @"401UnauthorizedRequestEncountered";

// UI configuration
static const CGFloat SIBLING_SPACING = 8.0f;
static const CGFloat SUPERVIEW_SPACING = 20.0f;

UIColor *Color(int red, int green, int blue);
UIColor *ColorA(int red, int green, int blue, CGFloat alpha);

#define STATUS_BAR_HEIGHT 20

// In app purchase config
#define IAP_SHARED_SECRET @"e5a5438524c64f7db49fb672bd5ab9a7"
