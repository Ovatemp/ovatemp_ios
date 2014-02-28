//
//  OvatempTestHelpers.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "XCTestCase+KIF.h"

#define WINDOW [[UIApplication sharedApplication] windows].firstObject
#define ROOT_VIEW_CONTROLLER [WINDOW rootViewController]
#define ACTIVE_VIEW_CONTROLLER TopMostViewController(ROOT_VIEW_CONTROLLER)

UIViewController *TopMostViewController(UIViewController *aViewController);
