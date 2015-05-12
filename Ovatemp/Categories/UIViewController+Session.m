//
//  UIViewController+Session.m
//  Ovatemp
//
//  Created by Flip Sasser on 4/14/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "UIViewController+Session.h"

#import "RootViewController.h"

@implementation UIViewController (Session)

- (void)backOutToRootViewController {
  if (self.navigationController) {
    [self.navigationController backOutToRootViewController];
  } else if (self.tabBarController) {
    [self.tabBarController backOutToRootViewController];
  } else {
    [((RootViewController *)self.parentViewController) launchAppropriateViewController];
  }
}

- (void)logout {
  [Configuration logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName: kUserDidLogoutNotification object: self];
  [self backOutToRootViewController];
}

@end
