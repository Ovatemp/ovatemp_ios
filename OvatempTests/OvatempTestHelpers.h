//
//  OvatempTestHelpers.h
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "XCTestCase+KIF.h"

#define window [[UIApplication sharedApplication] windows].firstObject
#define rootViewController [window rootViewController]
#define activeViewController TopMostViewController(rootViewController)

UIViewController *TopMostViewController(UIViewController *aViewController);