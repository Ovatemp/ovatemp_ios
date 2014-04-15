//
//  RootViewController.h
//  Ovatemp
//
//  Created by Chris Cahoon on 3/12/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionViewController.h"

@interface RootViewController : UIViewController <UITabBarControllerDelegate>

- (void)launchAppropriateViewController;
- (void)refreshToken;

@end
