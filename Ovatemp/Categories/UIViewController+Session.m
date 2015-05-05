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
      NSLog(@"FIRST");
    [self.navigationController backOutToRootViewController];
  } else if (self.tabBarController) {
      NSLog(@"SECOND");
    [self.tabBarController backOutToRootViewController];
  } else {
      NSLog(@"THIRD");
    [((RootViewController *)self.parentViewController) launchAppropriateViewController];
  }
}

- (void)logout {
  [Configuration logOut];
  [self backOutToRootViewController];
}

@end
