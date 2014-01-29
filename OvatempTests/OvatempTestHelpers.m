//
//  OvatempTestHelpers.m
//  Ovatemp
//
//  Created by Flip Sasser on 1/28/14.
//  Copyright (c) 2014 Back Forty. All rights reserved.
//

#import "OvatempTestHelpers.h"

UIViewController *TopMostViewController(UIViewController *aViewController) {
  if ([aViewController isKindOfClass:[UITabBarController class]]) {
    UITabBarController* tabBarController = (UITabBarController*)aViewController;
    return TopMostViewController(tabBarController.selectedViewController);
  } else if ([aViewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController* navigationController = (UINavigationController*)aViewController;
    return TopMostViewController(navigationController.visibleViewController);
  } else if (aViewController.presentedViewController) {
    UIViewController* presentedViewController = aViewController.presentedViewController;
    return TopMostViewController(presentedViewController);
  } else {
    return aViewController;
  }
}